class Front::CreditcardsController < FrontMemberController
  layout 'front_modal'

  before_action :set_item

  # メソッド
  def index
    @creditcards = current_user.creditcards.without_deleted
  end

  def new
    @creditcard = Creditcard.new
  end

  def create
    # 顧客IDがなければ顧客オブジェクトを作成
    if current_user.stripe_customer_id.blank?
      res = Stripe::Customer.create
      current_user.update!(stripe_customer_id: res.id)
    end

    # クレカオブジェクトを作成
    res = Stripe::Customer.create_source(
      current_user.stripe_customer_id,
      { source: params[:token] },
    )

    new_card = current_user.creditcards.create!(
      status: 'available',
      stripe_creditcard_id: res.id,
      masked_number: ('*' * 12) + res.last4,
      expire_date: Creditcard.parse_expire_date(res.exp_month, res.exp_year),
      brand: res.brand,
    )

    current_user.update!(selected_creditcard_id: new_card.id)
    flash[:success] = 'クレジットカードを登録しました。'
    redirect_to payment_confirm_item_path(@item)

  rescue Stripe::CardError => e
    flash[:danger] = e.message
    redirect_to action: :new
  end

  def card_update
    if current_user.update(user_params)
      flash[:success] = '選択クレジットカードを変更しました。'
      redirect_to payment_confirm_item_path(@item)
    else
      flash.now[:danger] = '選択クレジットカードを変更できませんでした。'
      render :index
    end
  end

  def destroy
    creditcards = current_user.creditcards.without_deleted
    creditcard = creditcards.find(params[:id])

    # クレカオブジェクトを削除
    res = Stripe::Customer.delete_source(
      current_user.stripe_customer_id,
      creditcard.stripe_creditcard_id,
    )

    # クレカを論理削除
    if creditcard.logical_delete
      if current_user.selected_creditcard_id == creditcard.id
        current_user.update!(selected_creditcard_id: nil)
      end
      flash[:success] = 'クレジットカードを削除しました。'
    else
      flash[:alert] = 'クレジットカードを削除できませんでした。'
    end

    # クレカが全て論理削除されたらクレカ新規登録画面に遷移
    if creditcards.where(deleted_at: nil).empty?
      redirect_to new_item_creditcard_path(@item)
    else
      redirect_to item_creditcards_path(@item)
    end

  rescue Stripe::CardError => e
    flash[:danger] = e.message
    redirect_to action: :index
  end

  private

  def user_params
    params.require(:user).permit(:selected_creditcard_id)
  end

  def set_item
    @item = Item.find(params[:item_id])
  end
end
