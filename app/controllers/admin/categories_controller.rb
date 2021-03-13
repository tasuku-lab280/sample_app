class Admin::CategoriesController < AdminController
  # 定数
  INDEX_PER_CAGORIES = 10


  # フック


  # メソッド
  def index
    one = search_categories
    @categories = one.page(params[:page]).per(params[:per_page] || INDEX_PER_CAGORIES)
  end

  def order_edit
  end

  private

  def search_categories
    one = Category.all
    
    # 絞込
    one = one.where('categories.name LIKE ?', '%' + params[:name] + '%') if params[:name].present?
    one = one.where('categories.seq LIKE ?', '%' + params[:seq] + '%') if params[:seq].present?
    one = one.where('categories.seq_path LIKE ?', '%' + params[:seq_path] + '%') if params[:seq_path].present?

    one
  end
end
