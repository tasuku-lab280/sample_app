class Api::PostsController < ApplicationController
  def index
    posts_needed = Post.joins(:user)
    .select("
      posts.id,
      posts.content,
      posts.category,
      user_id,
      posts.created_at,
      users.name AS user_name
      ")
    .order(created_at: :desc)
    render json: posts_needed
  end


  private
  def post_params
    params.permit(:content, :category)
  end
end
