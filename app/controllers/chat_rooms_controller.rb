class ChatRoomsController < ApplicationController
  def show
    # 投稿一覧表示に利用
    @chat_messages = ChatMessage.includes(:user).order(:id)
    # メッセージ投稿に利用
    @chat_message = current_user.chat_messages.new
  end
end
