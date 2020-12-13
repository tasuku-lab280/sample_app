class Front::Payments::CreditcardsController < FrontMemberController
  layout 'front_modal'

  # メソッド
  def index
    @creditcards = current_user.creditcards.without_deleted
  end

  def new
    @creditcard = Creditcard.new
  end

  def create
  end

  def destroy
    creditcards = current_user.creditcards.without_deleted
    creditcard = creditcards.find(params[:id])

    if creditcard.logical_delete
      flash[:success] = 'クレジットカードを削除しました。'
    else
      flash[:alert] = 'クレジットカードを削除できませんでした。'
    end

    # クレカが全て論理削除されたらクレカ新規登録画面に遷移
    if creditcards.where(deleted_at: nil).empty?
      redirect_to action: :new
    else
      redirect_to action: :index
    end
  end
end
