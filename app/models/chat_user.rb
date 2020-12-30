# == Schema Information
#
# Table name: chat_users
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chat_room_id :integer          not null
#  user_id      :integer          not null
#
# Indexes
#
#  index_chat_users_on_chat_room_id_and_user_id  (chat_room_id,user_id)
#
class ChatUser < ApplicationRecord
  belongs_to :chat_room
  belongs_to :user
end
