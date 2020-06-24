class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }
  def template
    ApplicationController.renderer.render partial: 'chat_messages/chat_message', locals: { message: self }
  end
end
