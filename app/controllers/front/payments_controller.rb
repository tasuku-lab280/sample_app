class Front::PaymentsController < FrontMemberController
  layout 'front_modal'

  before_action :set_item, only: [:confirm, :update]

  # メソッド
  def confirm
    if current_user.selected_creditcard_id.present?
      @selected_creditcard = current_user.creditcards.without_deleted.find(current_user.selected_creditcard_id)
    end
    if current_user.selected_destination_id.present?
      @selected_destination = current_user.destinations.find(current_user.selected_destination_id)
    end
  end

  def update
  end

  def finish
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end
end
