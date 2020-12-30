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
        where(arel_table[:seq_path].matches("#{node.seq_path}%"))
      end

      def subtree_of(node)
        node = to_node(node)
        descendants_of(node).or(arel_table[:id].eq(node.id))
      end

      def level(level) # root(/)からの深さ指定(Model.level(0)は常に[])
        arel_length = ->(args) { Arel::Nodes::NamedFunction.new('LENGTH', args) }
        arel_replace = ->(args) { Arel::Nodes::NamedFunction.new('REPLACE', args) }

        seq_without_delimiter = arel_replace.call([arel_table[:seq_path], Arel.sql("'#{DELIMITER}'"), Arel.sql("''")])
        depth = Arel::Nodes::InfixOperation.new(
          '-', arel_length.call([arel_table[:seq_path]]), arel_length.call([seq_without_delimiter])
        )
        where(depth.eq(level + 1))
      end

      def order_tree
        order(seq_path: :asc)
      end


      # クラスメソッド
      def to_node(obj)
        case obj
        when self then obj
        when String, Integer then find(obj)
        else raise ArgumentError, "非対応のクラス(obj: #{obj.class})"
        end
      end
    end


    # Ancestors
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


    # Parent
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


    # Children
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


    # Siblings
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


    # Descendants
    def descendants
      self.class.descendants_of(self).order_tree
    end

    def has_descendants?
      descendants.exists?
    end

    def descendants_of?(node)
      ancestor_seq_paths.include?(node.seq_path)
    end


    # Subtree
    def subtree
      self.class.subtree_of(self).order_tree
    end
  end
end
