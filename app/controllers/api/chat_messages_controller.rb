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

  def destroy
    chat_message = ChatMessage.find(params[:id])
    if chat_message.destroy
      head :no_content, status: :ok
    else
      render json: chat_message.errors, status: :unprocessable_entity
    end
  end
end
