# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  note       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Category < ApplicationRecord
  # モジュール


  # 定数


  # 関連
  has_many :items


  # 委譲


  # スコープ


  # フック


  # バリデーション
  validates :name,                    presence: true
                                      # length: { maximum: 255, allow_blank: true }
                                      # uniqueness: false
                                      # format: false
  validates :note,                    # presence: false
                                      length: { maximum: 1024, allow_blank: true }
                                      # uniqueness: false
                                      # format: false


  # クラス変数


  # クラスメソッド


  # クラスメソッド(Private)


  # メソッド


  # メソッド(Private)
end
