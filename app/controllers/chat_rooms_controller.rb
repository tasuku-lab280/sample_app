class ChatRoomsController < ApplicationController
  # 定数
  INDEX_PER_CHAT_ROOMS = 10

  def index
    @chat_rooms = current_user.chat_rooms
                  .page(params[:page]).per(params[:per_page] || INDEX_PER_CHAT_ROOMS)
                  .order(created_at: :desc)
    @chat_room = ChatRoom.new
    @chat_room.users << current_user
  end

  def create
    @chat_room = ChatRoom.new(chat_room_params)
    if @chat_room.save
      redirect_to chat_rooms_path, notice: 'チャットルーム作成ができました'
    else
      render :index
    end
  end

  def show
    # 投稿一覧表示に利用
    @chat_messages = ChatMessage.includes(:user).order(:id)
    # メッセージ投稿に利用
    @chat_message = current_user.chat_messages.new
  end

  def search
    @users = User.search(params[:keyword], current_user)
    render json: @users
  end

  private

  def chat_room_params
    params.require(:chat_room).permit(:name, { user_ids: [] } )
  end
end
