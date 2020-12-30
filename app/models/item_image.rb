# == Schema Information
#
# Table name: item_images
#
#  id         :bigint           not null, primary key
#  image      :string(255)      not null
#  note       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_id    :integer
#
# Indexes
#
#  index_item_images_on_item_id  (item_id)
#
class ItemImage < ApplicationRecord
  # モジュール
  mount_uploader :image, ItemImageUploader


  # 定数


  # 関連
  belongs_to :item


  # 委譲


  # スコープ
  scope :only_thumbnail, -> { where(id: group(:item_id).having(arel_table[:id].minimum)) }


  # フック


  # バリデーション
  validates :image,                   presence: true
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
