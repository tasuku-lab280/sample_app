class Admin::ItemsController < AdminController
  # 定数
  INDEX_PER_ITEMS = 10
  PERMITTED_ATTRIBUTES = %i(name body price condition image note)


  # フック


  # メソッド
  def index
    one = search_items
    @csv_data = one
    @items = one.page(params[:page]).per(params[:per_page] || INDEX_PER_ITEMS)

    respond_to do |format|
      format.html do
        @items
      end 
      format.csv do
        send_data render_to_string, filename: "(ファイル名).csv", type: :csv
      end
    end
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
  end


  # メソッド(Private)
  private

  def search_items
    one = Item.all
    
    # 絞込
    one = one.where('items.name LIKE ?', '%' + params[:name] + '%') if params[:name].present?
    one = one.where('items.body LIKE ?', '%' + params[:body] + '%') if params[:body].present?
    one = one.where('items.price LIKE ?', '%' + params[:price] + '%') if params[:price].present?
    # one = one.where(condition: params[:condition]) if params[:condition].present?

    # # ソート
    # one = one.order(created_at: :desc) if params[:sort_order] == 'created_desc'
    # one = one.order(price: :asc) if params[:sort_order] == 'price_asc'
    # one = one.order(price: :desc) if params[:sort_order] == 'price_desc'

    one
  end

  def item_params
    params.require(:item).permit(*PERMITTED_ATTRIBUTES)
  end
end
