# == Schema Information
#
# Table name: item_categories
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :string(255)      not null
#  item_id     :string(255)      not null
#
# Indexes
#
#  index_item_categories_on_category_id_and_item_id  (category_id,item_id)
#
class ItemCategory < ApplicationRecord
  # モジュール


  # 定数


  # アクセサ


  # 関連
  belongs_to :category, optional: true
  belongs_to :item, optional: true


  # 委譲


  # スコープ


  # フック


  # バリデーション
  validates :category_id,         presence: true
                                  # length: falsefalse,
                                  # uniqueness: false,
                                  # format: false
  validates :item_id,             presence: true
                                  # length: falsefalse,
                                  # uniqueness: false,
                                  # format: false


  # クラス変数


  # クラスメソッド


  # クラスメソッド(Private)


  # メソッド


  # メソッド(Private)
end
