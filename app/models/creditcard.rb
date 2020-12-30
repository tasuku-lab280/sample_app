# == Schema Information
#
# Table name: creditcards
#
#  id              :bigint           not null, primary key
#  brand           :string(255)      not null
#  deleted_at      :datetime
#  expiration_date :string(255)      not null
#  masked_number   :string(255)      not null
#  note            :text(65535)
#  status          :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :integer          not null
#
# Indexes
#
#  index_creditcards_on_user_id  (user_id)
#

#
# = クレジットカード
#
class Creditcard < ApplicationRecord
  # モジュール
  include Deletable
  extend Enumerize
  enumerize :status, in: %i(available unavailable), predicates: { prefix: true }, scope: true


  # 定数
  EXPIRATION_DATE_FORMAT = /\A[0-2]\d\/\d{2}\z/


  # 関連
  belongs_to :user, optional: true
  has_many :payments


  # 委譲


  # スコープ


  # フック
  # before_destroy -> { throw :abort }


  # バリデーション
  validates :user_id,                 presence: true
                                      # length: { maximum: 255 },
                                      # uniqueness: false,
                                      # format: false
  validates :status,                  presence: true
                                      # length: { maximum: 255 },
                                      # uniqueness: false,
                                      # format: false
  validates :brand,                   presence: true,
                                      length: { maximum: 255, allow_blank: true }
                                      # uniqueness: false,
                                      # format: false
  validates :expiration_date,         presence: true,
                                      length: { maximum: 255, allow_blank: true },
                                      # uniqueness: false,
                                      format: { with: EXPIRATION_DATE_FORMAT, allow_blank: true }
  validates :masked_number,           presence: true,
                                      length: { maximum: 255, allow_blank: true }
                                      # uniqueness: false,
                                      # format: false
  validates :note,                    # presence: false,
                                      length: { maximum: 1024, allow_blank: true }
                                      # uniqueness: false,
                                      # format: false
  # validates :deleted_at,              presence: false,
                                      # length: { maximum: 255 },
                                      # uniqueness: false,
                                      # format: false


  # クラス変数


  # クラスメソッド


  # クラスメソッド(Private)


  # メソッド
  def logical_delete
    # ＠TODO updateとの違い
    assign_attributes(
      status: :unavailable,
      masked_number: '*' * 16,
      expiration_date: '01/01',
      note: nil,
      deleted_at: Time.current,
    )

    save
  end


  # メソッド(Private)
end
