# == Schema Information
#
# Table name: chat_messages
#
#  id           :bigint           not null, primary key
#  content      :text(65535)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chat_room_id :integer          not null
#  user_id      :integer          not null
#
# Indexes
#
#  index_chat_messages_on_chat_room_id_and_user_id  (chat_room_id,user_id)
#
class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }
  def template
    ApplicationController.renderer.render partial: 'chat_messages/chat_message', locals: { message: self }
  end
end
