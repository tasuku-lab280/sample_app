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

    redirect_to action: :new and return if creditcards.empty?
    redirect_to action: :index
  end
end
