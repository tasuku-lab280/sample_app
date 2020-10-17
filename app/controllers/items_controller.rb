class ItemsController < ApplicationController
  # 定数
  INDEX_PER_ITEMS = 50
  PERMITTED_ATTRIBUTES = %i(category_id name body price condition delivery_fee sales_status note)
  NESTED_ATTRIBUTES = %i(id item_id image)


  # フック


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
  end


  # メソッド(Private)
  private

  def search_items
    one = Item.all
    
    # 絞込
    one = one.where('items.name LIKE ?', '%' + params[:keyword] + '%') if params[:keyword].present?
    one = one.where(condition: params[:condition]) if params[:condition].present?
    one = one.joins(:category).where(categories: { id: params[:category_parent] }) if params[:category_parent].present?

    # ソート
    one = one.order(created_at: :desc) if params[:sort_order] == 'created_desc'
    one = one.order(price: :asc) if params[:sort_order] == 'price_asc'
    one = one.order(price: :desc) if params[:sort_order] == 'price_desc'

    one
  end

  def item_params
    params.require(:item).permit(*PERMITTED_ATTRIBUTES, item_images_attributes: [:id, :item_id, :image])
  end
end
