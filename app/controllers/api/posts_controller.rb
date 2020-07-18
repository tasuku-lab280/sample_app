class Api::PostsController < ApplicationController
  def index
    @posts = Post.all
    render json: @posts
  end


  private
  def post_params
    params.permit(:content, :category)
  end
end
