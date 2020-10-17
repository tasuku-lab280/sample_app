class Item < ApplicationRecord
  # モジュール
  extend Enumerize
  enumerize :condition, in: %i(good somewhat_good normal somewhat_bad bad), predicates: { prefix: true }, scope: true
  enumerize :delivery_fee, in: %i(cash_delivery postage_included), predicates: { prefix: true }, scope: true
  enumerize :sales_status, in: %i(sales sold_out), predicates: { prefix: true }, scope: true


  # 定数


  # 関連
  belongs_to :user
  belongs_to :category


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
  # validates :image,                   presence: false
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