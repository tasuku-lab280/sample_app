# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  email                   :string(255)      default(""), not null
#  encrypted_password      :string(255)      default(""), not null
#  name                    :string(255)      not null
#  remember_created_at     :datetime
#  reset_password_sent_at  :datetime
#  reset_password_token    :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  selected_creditcard_id  :integer
#  selected_destination_id :integer
#  stripe_customer_id      :string(255)
#
# Indexes
#
#  index_users_on_email                    (email) UNIQUE
#  index_users_on_reset_password_token     (reset_password_token) UNIQUE
#  index_users_on_selected_creditcard_id   (selected_creditcard_id)
#  index_users_on_selected_destination_id  (selected_destination_id)
#
class User < ApplicationRecord
  # モジュール


  # 定数


  # 関連
  belongs_to :selected_creditcard, optional: true, class_name: 'Creditcard'
  has_many :destinations, dependent: :destroy
  has_many :creditcards
  has_many :payments
  has_many :posts, dependent: :destroy
  has_many :chat_messages, dependent: :nullify
  has_many :chat_users, dependent: :nullify
  has_many :chat_rooms, through: :chat_users
  has_many :items, dependent: :destroy
  has_many :comments, dependent: :nullify
  has_many :notices, dependent: :nullify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name,  presence: true,
                    length: { maximum: 30 }


  # 委譲
  
  
  # スコープ
  scope :where_category, ->(category) { where(posts: { category: category }) }


  # バリデーション
  # validates :selected_creditcard_id,      presence: false
                                          # length: false
                                          # uniqueness: false
                                          # format: false
  # validates :selected_destination_id,     presence: false
                                          # length: false
                                          # uniqueness: false
                                          # format: false
  # validates :stripe_customer_id,          presence: false
                                          # length: false
                                          # uniqueness: false
                                          # format: false


  # フック


  # メソッド
  def self.guest
    find_or_create_by!(name: 'ゲストユーザー', email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
  end

  def self.search(search, current_user)
    User.where.not(id: current_user.id).where('name LIKE(?)', "%#{search}%")
  end
end
