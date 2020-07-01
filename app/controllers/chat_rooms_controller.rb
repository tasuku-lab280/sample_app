class ChatRoomsController < ApplicationController
  # 定数
  INDEX_PER_CHAT_ROOMS = 10

  def index
    @chat_rooms = current_user.chat_rooms
                  .page(params[:page]).per(params[:per_page] || INDEX_PER_CHAT_ROOMS)
  end

  def new
    @chat_room = ChatRoom.new
    @chat_room.chat_users.build
    @users = User.all

    @search_users = User.none
    @search_users = User.search(params[:keyword]) if params[:keyword].present?
  end

  def create

  end

  def show
    # 投稿一覧表示に利用
    @chat_messages = ChatMessage.includes(:user).order(:id)
    # メッセージ投稿に利用
    @chat_message = current_user.chat_messages.new
  end
end
