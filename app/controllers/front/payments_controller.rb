class Front::PaymentsController < FrontMemberController
  layout 'front_modal'

  # メソッド
  def confirm
    @item = Item.find(params[:item_id])
  end
end
