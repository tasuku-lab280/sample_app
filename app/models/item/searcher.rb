class Item
  class Searcher
    # モジュール
    include ActiveModel::Model
    def self.i18n_scope; :activerecord; end


    # 定数
    ITEM_KEYWORDS_SEARCH_ATTRIBUTES = %i(name body)
    VALID_SEARCH_WORDS_LENGTH_FROM = 3
    STRONG_PARAMETER = [
      :keywords, :category_id, :min_price, :max_price, condition: [], delivery_fee: [], sales_status: [],
    ]


    # アクセサ
    ATTRIBUTES = %w(keywords category_id min_price max_price condition delivery_fee sales_status)
    attr_accessor(*ATTRIBUTES)


    # 委譲
    def category; Category.find(category_id); end
    # def items; Item.front_default; end
    def items_arel; Item.arel_table; end


    # バリデーション
    # validate :check_keyword_presence_if_category_id_none
    # validate :check_keyword_length_valid?, if: :keywords?


    # クラスメソッド
    # def self.attribute_names
    #   STRONG_PARAMETER
    # end


    # メソッド
    def category_id?
      category_id.present?
    end

    def keywords
      @keywords ||= ''
    end

    def search_words
      keywords.gsub(/　/, ' ').split(' ')
    end

    def search_words_length
      search_words.sum(&:length)
    end

    def keywords?
      search_words.present?
    end

    def only_sale?
      !(only_sale.to_s == '0' || only_sale.blank?)
    end

    def min_price
      @min_price.present? ? @min_price.to_i : 0
    end

    def min_price?
      @min_price.present?
    end

    def max_price
      @max_price.present? ? @max_price.to_i : Float::INFINITY
    end

    def max_price?
      @max_price.present?
    end

    def min_or_max_prices?
      min_price? || max_price?
    end

    def search
      return Item.none unless valid?

      one = Item.all
      # one = filter_by_category_id(one) if category_id?
      one = filter_by_keywords(one) if keywords?
      one = filter_by_prices(one) if min_or_max_prices?
      one = one.where(condition: condition) if condition.present?
      one = one.where(delivery_fee: delivery_fee) if delivery_fee.present?
      one = one.where(sales_status: sales_status) if sales_status.present?
      one
    end

    def search_by_only_category_id
      one = items
      one = filter_by_category_id(one) if category_id?
      one
    end


    # メソッド(private)
    private

    def check_keyword_presence_if_category_id_none
      return true if category_id? || keywords?

      errors.add(:keywords, "は#{VALID_SEARCH_WORDS_LENGTH_FROM}文字以上にしてください。")
    end

    def check_keyword_length_valid?
      return true if search_words_length >= VALID_SEARCH_WORDS_LENGTH_FROM

      errors.add(:keywords, "は#{VALID_SEARCH_WORDS_LENGTH_FROM}文字以上にしてください。")
    end

    def filter_by_category_id(collection)
      collection.joins(:item_categories).merge(ItemCategory.where(category_id: category.subtree))
    end

    def filter_by_keywords(collection)
      where_clause = search_words.map do |search_word|
        ITEM_KEYWORDS_SEARCH_ATTRIBUTES.map { |attr| items_arel[attr].matches("%#{search_word}%") }.inject(&:or)
      end.inject(&:and)
      collection.where(where_clause)
    end

    def filter_by_only_sale(collection)
      collection.only_sale
    end

    def filter_by_prices(collection)
      collection.where(items_arel[:price].in(min_price..max_price))
    end
  end
end
