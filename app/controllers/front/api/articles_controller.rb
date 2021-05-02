class Front::Api::ArticlesController < ApplicationController
  # モジュール
  respond_to :json, :js


  # 定数
  INDEX_PER_ARTICLES = 30


  # メソッド
  def index
    @article_searcher = Article::Searcher.new(article_searcher_params)
    @articles = @article_searcher.search.page(params[:page]).per(params[:per_page] || INDEX_PER_ARTICLES)

    respond_with @articles
  end


  # メソッド(Private)
  private
  
  def article_searcher_params
    params.permit(Article::Searcher::attribute_names)
  end
end
