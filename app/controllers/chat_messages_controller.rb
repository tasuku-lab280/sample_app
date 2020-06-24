class ChatMessagesController < ApplicationController
  def create
    @chat_message = current_user.chat_messages.create!(chat_message_params)
    ActionCable.server.broadcast 'chat_room_channel', chat_message: @chat_message.template
  end

  private
  def chat_message_params
    params.require(:chat_message).permit(:content)
  end
end
