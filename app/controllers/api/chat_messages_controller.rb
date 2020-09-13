class Api::ChatMessagesController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  
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

  def create
    chat_message = ChatMessage.new(post_params)
    if chat_message.save
      render json: { status: 'SUCCESS', data: chat_message }
    else
      render json: { status: 'ERROR', data: chat_message.errors }
    end
  end

  def destroy
    @chat_message.destroy
    render json: { status: 'SUCCESS', message: 'Deleted the post', data: @chat_message }
  end

  private

  def set_chat_message
    @chat_message = ChatMessage.find(params[:id])
  end

  def chat_message_params
    params.require(:chat_message).permit(:chat_room_id, :user_id, :content)
  end
end
