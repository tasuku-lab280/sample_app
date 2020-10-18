# == Schema Information
#
# Table name: items
#
#  id           :bigint           not null, primary key
#  body         :text(65535)      not null
#  condition    :string(255)      not null
#  days_to_ship :string(255)      not null
#  delivery_fee :string(255)      not null
#  name         :string(255)      not null
#  note         :text(65535)
#  prefecture   :integer          not null
#  price        :integer          not null
#  sales_status :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  category_id  :integer          not null
#  user_id      :integer          not null
#
# Indexes
#
#  index_items_on_user_id_and_category_id  (user_id,category_id)
#
class Item < ApplicationRecord
  # モジュール
  extend Enumerize
  enumerize :condition, in: %i(good somewhat_good normal somewhat_bad bad), predicates: { prefix: true }, scope: true
  enumerize :delivery_fee, in: %i(cash_delivery postage_included), predicates: { prefix: true }, scope: true
  enumerize :days_to_ship, in: %i(ships_in_1-2 ships_in_2-3 ships_in_4-7), predicates: { prefix: true }, scope: true
  enumerize :sales_status, in: %i(sales sold_out), predicates: { prefix: true }, scope: true
  include Prefecture


  # 定数


  # 関連
  has_many :item_images, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :category
  accepts_nested_attributes_for :item_images, allow_destroy: true


  # 委譲
  def user_name; user.name; end
  def category_name; category.name; end


  # スコープ


  # フック


  # バリデーション
  validates :user_id,                 presence: true
                                      # length: { maximum: 255, allow_blank: true }
                                      # uniqueness: false
                                      # format: false
  validates :name,                    presence: true
                                      # length: { maximum: 255, allow_blank: true }
                                      # uniqueness: false
                                      # format: false
  validates :body,                    presence: true,
                                      length: { maximum: 255 }
                                      # uniqueness: false
                                      # format: false
  validates :price,                   presence: true,
                                      numericality: { only_integer: true }
                                      # uniqueness: false
                                      # format: false
  validates :condition,               presence: true
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
  def first_image
    if item_images.exists?
      item_images.first.image.url
    else
      'no-image.jpg'
    end
  end


  # メソッド(Private)
end
