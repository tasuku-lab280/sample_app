class Front::DestinationsController < FrontMemberController
  layout 'front_modal'

  before_action :set_item

  # メソッド
  def index
    @destinations = current_user.destinations
  end

  def new
    @destination = Destination.new
  end

  def create
  end

  def destination_update
    if current_user.update(user_params)
      flash[:success] = '選択配送先を変更しました。'
      redirect_to payments_confirm_path(item_id: @item.id)
    else
      flash.now[:danger] = '選択配送先を変更できませんでした。'
      render :index
    end
  end

  def destroy
    destinations = current_user.destinations
    destination = destinations.find(params[:id])

    if destination.destroy
      flash[:success] = '配送先を削除しました。'
    else
      flash[:alert] = '配送先を削除できませんでした。'
    end

    # 配送先が全て削除されたら配送先新規登録画面に遷移
    if destinations.exists?
      redirect_to payments_destination_path(item_id: @item.id)
    else
      redirect_to new_payments_destination_path(item_id: @item.id)
    end
  end

  private

  def user_params
    params.require(:user).permit(:selected_destination_id)
  end


  def set_item
    @item = Item.find(params[:item_id])
  end
end
