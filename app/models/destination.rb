# == Schema Information
#
# Table name: destinations
#
#  id              :bigint           not null, primary key
#  address1        :string(255)      not null
#  address2        :string(255)      not null
#  address3        :string(255)
#  first_name      :string(32)       not null
#  first_name_kana :string(32)       not null
#  last_name       :string(32)       not null
#  last_name_kana  :string(32)       not null
#  note            :text(65535)
#  postal_code     :string(255)      not null
#  prefecture      :integer          not null
#  tel             :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :integer          not null
#
# Indexes
#
#  index_destinations_on_user_id  (user_id)
#

#
# = 配送先
#
class Destination < ApplicationRecord
  # モジュール
  extend Enumerize
  include Prefecture


  # 定数


  # 関連
  belongs_to :user


  # 委譲


  # スコープ


  # フック


  # バリデーション
  validates :user_id,               presence: true
                                    # length: falsefalse,
                                    # uniqueness: false,
                                    # format: false
  validates :last_name,             presence: true,
                                    length: { maximum: 32, allow_blank: true },
                                    # uniqueness: false
                                    # format: false
                                    striped: true
  validates :first_name,            presence: true,
                                    length: { maximum: 32, allow_blank: true },
                                    # uniqueness: false
                                    # format: false
                                    striped: true
  validates :last_name_kana,        presence: true,
                                    length: { maximum: 32, allow_blank: true },
                                    # uniqueness: false,
                                    katakana: { allow_blank: true },
                                    striped: true
  validates :first_name_kana,       presence: true,
                                    length: { maximum: 32, allow_blank: true },
                                    # uniqueness: false,
                                    katakana: { allow_blank: true },
                                    striped: true
  validates :postal_code,           presence: true,
                                    length: { is: 7, allow_blank: true },
                                    # uniqueness: false
                                    numericality: { only_integer: true, allow_blank: true }
  validates :prefecture,            presence: true
                                    # length: false,
                                    # uniqueness: false
                                    # format: false
  validates :address1,              presence: true,
                                    length: { maximum: 255, allow_blank: true },
                                    # uniqueness: false
                                    # format: false
                                    striped: true
  validates :address2,              presence: true,
                                    length: { maximum: 255, allow_blank: true },
                                    # uniqueness: false
                                    # format: false
                                    striped: true
  validates :address3,              # presence: false,
                                    length: { maximum: 255, allow_blank: true },
                                    # uniqueness: false
                                    # format: false
                                    striped: true
  validates :tel,                   # presence: true,
                                    length: { in: 10..11, allow_blank: true },
                                    # uniqueness: false
                                    numericality: { only_integer: true, allow_blank: true }
  validates :note,                  # presence: false,
                                    length: { maximum: 1024 }
                                    # uniqueness: false
                                    # format: false


  # クラス変数


  # クラスメソッド


  # クラスメソッド(Private)


  # メソッド


  # メソッド(Private)
end
