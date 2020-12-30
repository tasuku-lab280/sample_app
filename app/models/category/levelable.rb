class Category
  module Levelable
    extend ActiveSupport::Concern
    # モジュール
    include NodeMethods


    # 定数
    DELIMITER = '/'
    PATH_FORMAT = /\A(\/\d+)+\/\z/


    included do
      # アクセサ
      attr_accessor :parent_seq_path # 仮想


      # 関連


      # 委譲


      # フック
      after_initialize :set_maximum_seq, if: :new_record?
      before_destroy :check_has_no_children


      # バリデーション
      # validates :seq,                     presence: false,
                                          # length: { maximum: 255, allow_blank: true },
                                          # uniqueness: false,
                                          # format: false
      validates :seq_path,                presence: true,
                                          length: { maximum: 255, allow_blank: true },
                                          # uniqueness: false,
                                          format: { with: PATH_FORMAT, allow_blank: true }

      validate :check_uncycled


      # クラスメソッド
      def self.replace_all_seq_path!(find_string, replace_with)
        update_all(["`#{table_name}`.`seq_path`=REPLACE(`#{table_name}`.`seq_path`, ?, ?)", find_string, replace_with])
      end
    end


    # メソッド
    def seq=(value)
      super
      replace_seq_path
    end

    def parent_seq_path=(value)
      value = DELIMITER unless PATH_FORMAT.match?(value)
      self.seq_path = value + seq.to_s + DELIMITER
    end

    def level
      seq_path.scan(/\d+/).count
    end

    def will_save_change_to_parent?
      will_save_change_to_seq_path?
    end


    # メソッド(Private)

    private

    def replace_seq_path(val: seq, val_was: seq_was)
      pathify = ->(target) { DELIMITER + target.to_s + DELIMITER }
      self.seq_path = seq_path? ? seq_path.gsub(pathify.call(val_was), pathify.call(val)) : pathify.call(val)
    end

    def set_maximum_seq
      self.seq = self.class.unscope(:where).maximum(:seq).to_i + 1
    end

    def check_has_no_children
      return unless has_children?

      msg = errors.generate_message(:base, 'restrict_dependent_destroy.has_many', record: self.class.model_name.human)
      errors.add(:base, msg)
      throw :abort
    end

    def check_uncycled
      return unless ancestor_seq_paths.include?(seq_path_was)
      errors.add(:parent_seq_path, 'は循環しています。')
    end
  end
end
