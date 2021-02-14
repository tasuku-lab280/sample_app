# == Schema Information
#
# Table name: creditcards
#
#  id                   :bigint           not null, primary key
#  brand                :string(255)      not null
#  deleted_at           :datetime
#  expire_date          :string(255)      not null
#  masked_number        :string(255)      not null
#  note                 :text(65535)
#  status               :string(255)      not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  stripe_creditcard_id :string(255)      not null
#  user_id              :integer          not null
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
  EXPIRE_DATE_FORMAT = /\A[0-1]\d\/\d{2}\z/


  # 関連
  belongs_to :user, optional: true
  has_many :payments


  # 委譲


  # スコープ


  # フック
  before_destroy :destroy?


  # バリデーション
  validates :user_id,                 presence: true
                                      # length: { maximum: 255 },
                                      # uniqueness: false,
                                      # format: false
  validates :status,                  presence: true
                                      # length: { maximum: 255 },
                                      # uniqueness: false,
                                      # format: false
  validates :stripe_creditcard_id,    presence: true
                                      # length: { maximum: 255 },
                                      # uniqueness: false,
                                      # format: false
  validates :masked_number,           presence: true,
                                      length: { maximum: 255, allow_blank: true }
                                      # uniqueness: false,
                                      # format: false
  validates :expire_date,             presence: true,
                                      length: { maximum: 255, allow_blank: true },
                                      # uniqueness: false,
                                      format: { with: EXPIRE_DATE_FORMAT, allow_blank: true }
  validates :brand,                   presence: true,
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
  def self.parse_expire_date(exp_month, exp_year)
    month = sprintf("%02d", exp_month)
    year = sprintf("%02d", exp_year % 100)
    return month + '/' + year
  end


  # クラスメソッド(Private)


  # メソッド
  def logical_delete
    assign_attributes(
      status: 'unavailable',
      stripe_creditcard_id: 'deleted',
      masked_number: '*' * 16,
      expire_date: '01/00',
      brand: 'deleted',
      note: nil,
      deleted_at: Time.current,
    )

    save
  end


  # メソッド(Private)
  private

  def destroy?
    if id != user.selected_creditcard_id
      errors.add(:base, '選択クレジットカードは削除できません')
      throw :abort
    end
  end
end
