class UsersController < ApplicationController
  # 定数
  INDEX_PER_POSTS = 5


  def index
    @users = filtered_users
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  private

  def filtered_users
    one = User.includes(:posts)
    one = if Post.category.values.include?(params[:category])
            @category = params[:category]
            one.where_category(params[:category])
          else
            one
          end
    one = one.page(params[:page]).per(params[:per_page] || INDEX_PER_POSTS)
    one
  end
end
