class Front::CategoriesController < FrontController
  # 定数
  INDEX_PER_ITEMS = 100


  # メソッド
  def show
    @category = Category.find(params[:id])
    @items = @category.items.order(created_at: :desc).page(params[:page])
            .per(params[:per_page] || INDEX_PER_ITEMS)
  end
end
