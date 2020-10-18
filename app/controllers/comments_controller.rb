class CommentsController < ApplicationController
  # 定数
  PERMITTED_ATTRIBUTES = %i(user_id item_id comment)

  # メソッド
  def create
    @comment = current_user.comments.build(comment_params)
    item = @comment.item

    respond_to do |format|
      if @comment.save!
        format.html { redirect_to item_path(item) }
        format.js
      else
        format.html { redirect_to item_path(item) }
        format.js { render :errors }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy!
    item = @comment.item
    redirect_to item_path(item)
  end

  private

  def comment_params
    params.require(:comment).permit(*PERMITTED_ATTRIBUTES)
  end
end
