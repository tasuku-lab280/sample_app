class Api::ChatMessagesController < ApplicationController
  def index
    chat_message = ChatMessage.joins(:user)
    .select("
      chat_messages.id,
      chat_messages.content,
      chat_messages.user_id,
      users.name AS user_name
      ")
    .order(created_at: :desc)
    render json: chat_message
  end
end
