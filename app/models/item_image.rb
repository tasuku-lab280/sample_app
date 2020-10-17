class ItemImage < ApplicationRecord
  # モジュール
  mount_uploader :image, ItemImageUploader


  # 定数


  # 関連
  belongs_to :item


  # 委譲


  # スコープ


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
