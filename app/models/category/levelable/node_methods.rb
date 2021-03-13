module Category::Levelable
  module NodeMethods
    extend ActiveSupport::Concern

    class_methods do
      # スコープ
      def ancestors_of(node)
        node = to_node(node)
        where(arel_table[:seq_path].in(node.ancestor_seq_paths))
      end

      def children_of(node)
        node = to_node(node)
        concat = Arel::Nodes::SqlLiteral.new("CONCAT('#{node.seq_path}', `#{table_name}`.`seq`, '#{DELIMITER}')")
        where(arel_table[:seq_path].eq(concat))
      end

      def siblings_of(node)
        node = to_node(node)
        return children_of(node.parent) if node.has_parent?

        concat = Arel::Nodes::SqlLiteral.new("CONCAT('#{DELIMITER}', `#{table_name}`.`seq`, '#{DELIMITER}')")
        where(arel_table[:seq_path].eq(concat))
      end

      def descendants_of(node)
        node = to_node(node)
        subtree_of(node).where.not(id: node)
      end

      def subtree_of(node)
        node = to_node(node)
        where(arel_table[:seq_path].matches("#{node.seq_path}%"))
      end

      def level(level) # root(/)からの深さ指定(Model.level(0)は常に[])
        where(_arel_seq_path_depth.eq(level))
      end

      def order_by_int_seq_path(dest = :asc) # `seq_path`の数字順ソート
        return current_scope unless (max_depth = maximum(_arel_seq_path_depth))

        arel_substring_index = ->(former, latter, index) do
          Arel::Nodes::NamedFunction.new('SUBSTRING_INDEX', [former, latter, index])
        end

        order_clms = Array.new(max_depth) do |i|
          one = Arel::Nodes::Case
                  .new
                  .when(arel_table[:seq_path].matches("#{DELIMITER}%"))
                  .then(
                    arel_substring_index.call(
                      arel_substring_index.call(arel_table[:seq_path], Arel.sql("'#{DELIMITER}'"), i + 2),
                      Arel.sql("'#{DELIMITER}'"),
                      -1
                    )
                  ).else(-1)
          Arel::Nodes::InfixOperation.new('+', one, 0) # Int型変換
        end
        order_clms.inject(current_scope || all) { |result, clm| result.order(clm.send(dest)) }
      end

      def order_tree
        order_by_int_seq_path(:asc)
      end


      # クラスメソッド
      def to_node(obj)
        case obj
        when self then obj
        when String, Integer then find(obj)
        else raise ArgumentError, "非対応のクラス(obj: #{obj.class})"
        end
      end

      #
      # レシーバのスコープ内で祖先を持たないノード
      # a/b/c
      # a/d/
      # Levelable.where(seq: [b, c, d]).roots_in_current_scope
      # #=> [b, d]
      #
      def roots_in_current_scope
        return all.send(__method__) unless current_scope

        table_alias = arel_table.alias
        condition = arel_table[:seq_path]
                      .matches(Arel::Nodes::NamedFunction.new('CONCAT', [table_alias[:seq_path], Arel.sql("'%'")]))
                      .and(arel_table[:id].not_eq(table_alias[:id]))
        subquery =  unscoped
                      .select(1)
                      .from(current_scope.select(arel_table[:id], arel_table[:seq_path]), table_alias.name)
                      .where(condition)
                      .arel
        where.not(subquery.exists)
      end

      #
      # レシーバのスコープ内で子孫を持たないノード
      # a/b/c
      # a/d/
      # Levelable.where(seq: [a, b, d]).leaves_in_current_scope
      # #=> [b, d]
      #
      def leaves_in_current_scope
        return all.send(__method__) unless current_scope

        table_alias = arel_table.alias
        condition = table_alias[:seq_path]
                      .matches(Arel::Nodes::NamedFunction.new('CONCAT', [arel_table[:seq_path], Arel.sql("'%'")]))
                      .and(table_alias[:id].not_eq(arel_table[:id]))
        subquery = unscoped
                     .select(1)
                     .from(current_scope.select(arel_table[:id], arel_table[:seq_path]), table_alias.name)
                     .where(condition)
                     .arel
        where.not(subquery.exists)
      end


      # クラスメソッド(private)
      private

      def _arel_seq_path_depth
        arel_length = ->(args) { Arel::Nodes::NamedFunction.new('LENGTH', args) }
        arel_subtraction = ->(former, latter) { Arel::Nodes::InfixOperation.new('-', former, latter) }

        seq_without_delim = Arel::Nodes::NamedFunction.new(
          'REPLACE', [arel_table[:seq_path], Arel.sql("'#{DELIMITER}'"), Arel.sql("''")]
        )
        one = arel_subtraction.call(arel_length.call([arel_table[:seq_path]]), arel_length.call([seq_without_delim]))
        arel_subtraction.call(one, 1)
      end
    end


    # Ancestors(自身の祖先一覧)
    # a/b/c
    # c.ancestors == [a, b]
    def ancestors
      return self.class.none unless has_parent?
      self.class.ancestors_of(self)
    end

    def ancestor_seq_paths
      seqs = seq_path.split(DELIMITER)[1..-2] # ルート('')と自身以外
      seqs.inject([DELIMITER]) { |seq_paths, seq| seq_paths << seq_paths.last + seq + DELIMITER } - [DELIMITER]
    end

    def ancestor_of?(node)
      node.ancestor_seq_paths.include?(seq_path)
    end


    # Parent(自身を直接の子として持つ親)
    # a/b/c
    # c.parent == b
    def parent
      self.class.find_by_seq_path(parent_seq_path) if has_parent?
    end

    def parent_seq_path
      ancestor_seq_paths.last
    end

    def has_parent?
      ancestor_seq_paths.present?
    end

    def parent_of?(node)
      self.seq_path == node.parent_seq_path
    end


    # Children(自身を直接の親とする子)
    # a/b/c
    # a/e/
    # a.children == [b, e]
    def children
      self.class.children_of(self)
    end

    def children_seq_paths
      children.pluck(:seq_path)
    end

    def has_children?
      children.exists?
    end

    def child_of?(node)
      self.parent_seq_path == node.seq_path
    end


    # Siblings(自身と同じ親を持つ兄弟)
    # a/b/c
    # a/e/
    # b.siblings == [b, e]
    # b.siblings(include_self: false) == [e]
    def siblings(include_self: true)
      scope = self.class.siblings_of(self)
      include_self ? scope : scope.where.not(id: id)
    end

    def sibling_seqs(include_self: true)
      siblings(include_self: include_self).pluck(:seqs)
    end

    def sibling_seq_paths(include_self: true)
      siblings(include_self: include_self).pluck(:seq_paths)
    end

    def has_siblings?
      siblings.exists?
    end

    def siblings_of?(node)
      self.ancestor_seq_paths == node.ancestor_seq_paths
    end


    # Descendants(子孫一覧)
    # a/b/c
    # a/e/
    # a.descendants == [b, c, e]
    def descendants
      self.class.descendants_of(self).order_tree
    end

    def descendants_in_database
      return self.class.none if new_record?
      return descendants unless seq_path_changed?

      self.class.find(id).descendants
    end

    def descendants_in_database_seq_paths
      descendants_in_database.pluck(:seq_path)
    end

    def has_descendants?
      descendants.exists?
    end

    def descendants_of?(node)
      ancestor_seq_paths.include?(node.seq_path)
    end


    # Subtree(自身をルートとする部分木)
    # a/b/c
    # a/b/d
    # b.subtree == [b, c, d]
    def subtree
      self.class.subtree_of(self).order_tree
    end
  end
end
