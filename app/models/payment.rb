# == Schema Information
#
# Table name: payments
#
#  id            :bigint           not null, primary key
#  error_message :string(255)
#  note          :text(65535)
#  price         :integer          not null
#  result_code   :string(255)
#  status        :string(255)      default("success"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  creditcard_id :integer          not null
#  item_id       :integer          not null
#  user_id       :integer          not null
#
# Indexes
#
#  index_payments_on_user_id_and_creditcard_id_and_item_id  (user_id,creditcard_id,item_id)
#

#
# = 決済
#
class Payment < ApplicationRecord
  # モジュール
  extend Enumerize
  enumerize :status, in: [:success, :error], predicates: { prefix: true }


  # 定数


  # アクセサ


  # 関連
  belongs_to :user, optional: true
  belongs_to :creditcard, optional: true
  belongs_to :item


  # 委譲
  def user_name; user.name; end


  # スコープ


  # フック
  before_destroy -> { throw :abort }


  # バリデーション
  validates :user_id,            presence: true
                                 # length: { maximum: 255 }
                                 # uniqueness: { scope: :group_id }
                                 # format: false
  validates :creditcard_id,      presence: true
                                 # length: { maximum: 255 }
                                 # uniqueness: { scope: :group_id }
                                 # format: false
  validates :item_id,            presence: true
                                 # length: { maximum: 255 }
                                 # uniqueness: { scope: :group_id }
                                 # format: false
  validates :status,             presence: true
                                 # length: { maximum: 255 }
                                 # uniqueness: { scope: :group_id }
                                 # format: false
  validates :price,              presence: true,
                                 # length: { maximum: 255 }
                                 # uniqueness: { scope: :group_id }
                                 # format: false
                                 numericality: {
                                   allow_blank: true,
                                   only_integer: true,
                                   greater_than_or_equal_to: 1,
                                   less_than_or_equal_to: 99_999_999
                                 }
  validates :result_code,        # presence: false
                                 length: { maximum: 255 }
                                 # uniqueness: { scope: :group_id }
                                 # format: false
  validates :error_message,      # presence: false
                                 length: { maximum: 255 }
                                 # uniqueness: { scope: :group_id }
                                 # format: false
  validates :note,               # presence: false,
                                 length: { maximum: 1024 }
                                 #  uniqueness: { scope: :group_id }
                                 #  format: false
  validate :is_owner_of_creditcard?


  # クラス変数


  # クラスメソッド


  # メソッド


  # メソッド(Private)

  private

  def is_owner_of_creditcard?
    return if user.creditcards.find_by(id: creditcard_id).present?
    errors.add(:base, '会員のクレジットカードではありません。')
  end
end
