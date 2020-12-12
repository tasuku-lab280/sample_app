class Front::PaymentsController < FrontMemberController
  layout 'front_modal'
  # 定数


  # フック


  # メソッド
  def confirm
    @item = Item.find(params[:item_id])
  end
end
