class CommentsController < ApplicationController
  # 定数
  PERMITTED_ATTRIBUTES = %i(user_id item_id body)


  # フック
  before_action :authenticate_user!, only: [:create, :destroy]


  # メソッド
  def create
    @comment = current_user.comments.build(comment_params)
    item = @comment.item

    respond_to do |format|
      if @comment.save
        format.html { redirect_to item_path(item) } 
        format.js
      else
        format.html { redirect_to item_path(item) } 
        format.js
      end
    end

    seller = @comment.item.user
    seller.notices.generate_by(:create_comment, @comment).save!
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(*PERMITTED_ATTRIBUTES)
  end
end
