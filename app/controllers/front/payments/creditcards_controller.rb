class Front::Payments::CreditcardsController < FrontMemberController
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
  end

  def card_update
    if current_user.update(user_params)
      flash[:success] = '選択クレジットカードを変更しました。'
      redirect_to payments_confirm_path(item_id: @item.id)
    else
      flash.now[:danger] = '選択クレジットカードを変更できませんでした。'
      render :index
    end
  end

  def destroy
    creditcards = current_user.creditcards.without_deleted
    creditcard = creditcards.find(params[:id])

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
      redirect_to new_payments_creditcard_path(item_id: @item.id)
    else
      redirect_to payments_creditcard_path(item_id: @item.id)
    end
  end

  private

  def user_params
    params.require(:user).permit(:selected_creditcard_id)
  end


  def set_item
    @item = Item.find(params[:item_id])
  end
end
