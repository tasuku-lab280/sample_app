class ChatRoom < ApplicationRecord
  has_many :chat_users, dependent: :destroy
  accepts_nested_attributes_for :chat_users, allow_destroy: true
  has_many :users, through: :chat_users
  has_many :chat_messeage, dependent: :destroy
end
