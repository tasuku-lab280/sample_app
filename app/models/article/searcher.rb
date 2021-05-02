class Article
  class Searcher
    # モジュール
    include ActiveModel::Model


    # 定数
    ARTICLE_KEYWORDS_SEARCH_ATTRIBUTES = %i(title body)


    # アクセサ
    ATTRIBUTES = %w(format keywords category_id)
    attr_accessor(*ATTRIBUTES)


    # 委譲
    def category; Category.find(category_id); end
    def articles; Article.front_default; end
    def articles_arel; Article.arel_table; end


    # バリデーション


    # クラスメソッド
    def self.attribute_names
      ATTRIBUTES
    end


    # メソッド
    def keywords
      @keywords ||= ''
    end

    def search_words
      keywords.gsub(/　/, ' ').split(' ')
    end

    def keywords?
      search_words.present?
    end

    def search
      one = articles
      one = filter_by_keywords(one) if keywords?
      one
    end


    # メソッド(private)
    private

    def filter_by_keywords(collection)
      where_clause = search_words.map do |search_word|
        ARTICLE_KEYWORDS_SEARCH_ATTRIBUTES.map { |attr| articles_arel[attr].matches("%#{search_word}%") }.inject(&:or)
      end.inject(&:and)
      collection.where(where_clause)
    end
  end
end
