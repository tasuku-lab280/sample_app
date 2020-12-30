class Front::ItemsController < FrontController
  # 定数
  INDEX_PER_ITEMS = 50
  PERMITTED_ATTRIBUTES = %i(category_id name body price condition delivery_fee sales_status note)
  NESTED_ATTRIBUTES = %i(id item_id image)


  # フック
  before_action :set_category, only: :index
  before_action :authenticate_user!, only: [:new, :create]


  # メソッド
  def index
    one = search_items
    @items = one.page(params[:page]).per(params[:per_page] || INDEX_PER_ITEMS)
  end

  def new
    @item = Item.new
  end

  def create
    @item = current_user.items.new(item_params)
    if @item.save
      redirect_to items_path, notice: '商品を出品しました。'
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
    @other_items = @item.user.items.order(created_at: :desc).limit(6)
  end


  # メソッド(Private)
  private

  def search_items
    one = Item.all
    
    # 絞込
    one = one.where('items.name LIKE ?', '%' + params[:keyword] + '%') if params[:keyword].present?
    one = one.joins(:item_categories).where(item_categories: { category_id: @category.descendants }) if params[:category_id].present?
    if params[:min_price].present?
      one = one.where('items.price >= ?', params[:min_price])
    end
    if params[:max_price].present?
      one = one.where('items.price <= ?', params[:max_price])
    end
    one = one.where(condition: params[:condition]) if params[:condition].present?
    one = one.where(delivery_fee: params[:delivery_fee]) if params[:delivery_fee].present?
    one = one.where(sales_status: params[:sales_status]) if params[:sales_status].present?

    # ソート
    one = one.order(created_at: :desc) if params[:sort_order] == 'created_desc'
    one = one.order(price: :asc) if params[:sort_order] == 'price_asc'
    one = one.order(price: :desc) if params[:sort_order] == 'price_desc'

    one
  end

  def item_params
    params.require(:item).permit(*PERMITTED_ATTRIBUTES, item_images_attributes: [:id, :item_id, :image])
  end

  def set_category
    @category = Category.find(params[:category_id]) if params[:category_id].present?
  end
end
