class Front::ItemsController < FrontController
  # レイアウト
  layout 'front_modal', only: :payment_confirm


  # 定数
  INDEX_PER_ITEMS = 50
  PERMITTED_ATTRIBUTES = %i(category_id name body price condition delivery_fee sales_status note)
  NESTED_ATTRIBUTES = %i(id item_id image)


  # フック
  before_action :set_category, only: :index
  before_action :authenticate_user!, only: [:new, :create, :payment_confirm, :payments, :payment_finish]
  before_action :set_item, only: [:payment_confirm, :payment]


  # メソッド
  def index
    @category = Category.find_by(id: params[:category_id])
    @item_searcher = Item::Searcher.new(item_searcher_params)
    order = Item::FRONT_ORDERS[params[:item_order]] || { created_at: :desc }
    @items = @item_searcher.search.order(order).page(params[:page]).per(params[:per_page] || INDEX_PER_ITEMS)
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

  def payment_confirm
    if current_user.selected_creditcard_id.present?
      @selected_creditcard = current_user.creditcards.without_deleted.find(current_user.selected_creditcard_id)
    end
    if current_user.selected_destination_id.present?
      @selected_destination = current_user.destinations.find(current_user.selected_destination_id)
    end
  end

  def payment
    if current_user.selected_creditcard.status == 'unavailable'
      flash[:danger] = '無効なクレジットカードです。'
      render :payment_confirm
      return
    end

    payment = current_user.payments.create!(
      creditcard_id: current_user.selected_creditcard_id,
      item_id: @item.id,
      price: @item.price,
    )

    # stripeに課金
    res = Stripe::Charge.create({
      amount: @item.price,
      currency: "jpy",
      customer: current_user.stripe_customer_id,
      source: current_user.selected_creditcard.stripe_creditcard_id,
    })

    redirect_to payment_finish_item_path(@item)

  rescue Stripe::CardError => e
    payment.update!(
      status: 'error',
      result_code: '',
      error_message: '',
    )
    flash[:danger] = e.message
    render :payment_confirm
  end

  def payment_finish
  end


  # メソッド(Private)
  private

  def item_params
    params.require(:item).permit(*PERMITTED_ATTRIBUTES, item_images_attributes: [:id, :item_id, :image])
  end

  def set_category
    @category = Category.find(params[:category_id]) if params[:category_id].present?
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def item_searcher_params
    params.permit(Item::Searcher::STRONG_PARAMETER)
  end
end
