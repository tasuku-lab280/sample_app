class ItemsController < ApplicationController
  # 定数
  INDEX_PER_ITEMS = 10
  PERMITTED_ATTRIBUTES = %i(name body price condition image note)


  # フック


  # メソッド
  def index
    @items = Item.page(params[:page]).per(params[:per_page] || INDEX_PER_ITEMS)
             .order(created_at: :desc)
  end


  # メソッド(Private)
  private

  def item_params
    params.require(:item).permit(*PERMITTED_ATTRIBUTES)
  end
end
