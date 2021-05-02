class Front::ArticlesController < FrontController
  # レイアウト


  # 定数
  INDEX_PER_ARTICLES = 30
  ARTICLE_KEYWORDS_SEARCH_ATTRIBUTES = %i(title body)


  # フック


  # メソッド
  def index
    @article_searcher = Article::Searcher.new(article_searcher_params)
    @articles = @article_searcher.search.page(params[:page]).per(params[:per_page] || INDEX_PER_ARTICLES)
  end

  def show
  end


  # メソッド(Private)
  def article_searcher_params
    params.permit(Article::Searcher::attribute_names)
  end
end
