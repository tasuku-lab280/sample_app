class Api::CommentsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    comment = Item.find(params[:item_id]).comments.joins(:user)
    .select("
      comments.id,
      comments.body,
      comments.created_at,
      user_id,
      users.name AS user_name
      ")
    render json: comment
  end

  def create
    @comment = Comment.new(comment_params)
    item = @comment.item

    if @comment.save
      render json: { status: 'SUCCESS', data: @comment }
      seller = @comment.item.user
      seller.notices.generate_by(:create_comment, @comment).save!
    else
      render json: { status: 'ERROR', data: @comment.errors }
    end
  end

  private
  def comment_params
    params.permit(:user_id, :item_id, :body)
  end
end
