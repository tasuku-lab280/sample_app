# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  detail     :text(65535)
#  image      :string(255)
#  name       :string(255)      not null
#  note       :text(65535)
#  seq        :integer
#  seq_path   :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_seq_path  (seq_path)
#
class Category < ApplicationRecord
  # モジュール
  include Levelable


  # 定数


  # 関連
  has_many :item_categories, dependent: :restrict_with_error
  has_many :items, through: :item_categories


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
