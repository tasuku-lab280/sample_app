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
#  user_id      :integer          not null
#
# Indexes
#
#  index_items_on_user_id  (user_id)
#
class Item < ApplicationRecord
  # モジュール
  extend Enumerize
  enumerize :condition, in: %i(new_unused nearly_unused no_dirty somewhat_dirty dirty bad), predicates: { prefix: true }, scope: true
  enumerize :delivery_fee, in: %i(cash_delivery postage_included), predicates: { prefix: true }, scope: true
  enumerize :days_to_ship, in: %i(ships_in_1-2 ships_in_2-3 ships_in_4-7), predicates: { prefix: true }, scope: true
  enumerize :sales_status, in: %i(sales sold_out), predicates: { prefix: true }, scope: true
  include Prefecture


  # 定数
  FRONT_ORDERS = {
    'price_asc' => { selling_price: :asc },
    'price_desc' => { selling_price: :desc },
    'created_at_desc' => { released_at: :desc },
  }


  # 関連
  has_one :item_thumbnail, -> { only_thumbnail }, class_name: 'ItemImage'
  has_many :item_images, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :item_categories, dependent: :restrict_with_error
  has_many :categories, through: :item_categories
  belongs_to :user
  accepts_nested_attributes_for :item_images, allow_destroy: true


  # 委譲
  def user_name; user.name; end
  def category_name; categories.name; end
  def thumbnail; item_thumbnail || 'no-image.jpg'; end


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
  def thumbnail; item_images.exists? ? item_images.first.image.url(:thumb) : 'no-image.jpg'; end


  # メソッド(Private)
end
