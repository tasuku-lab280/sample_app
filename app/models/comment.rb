# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_id    :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_comments_on_user_id_and_item_id  (user_id,item_id)
#
class Comment < ApplicationRecord
  # モジュール


  # 定数


  # 関連
  belongs_to :user
  belongs_to :item


  # 委譲
  def user_name; user.name; end


  # スコープ


  # フック


  # バリデーション
  validates :user_id,                 presence: true
                                      # length: { maximum: 255, allow_blank: true }
                                      # uniqueness: false
                                      # format: false
  validates :item_id,                 presence: true
                                      # length: { maximum: 255, allow_blank: true }
                                      # uniqueness: false
                                      # format: false
  validates :body,                    presence: true,
                                      length: { maximum: 1024, allow_blank: true }
                                      # uniqueness: false
                                      # format: false


  # クラス変数


  # クラスメソッド


  # クラスメソッド(Private)


  # メソッド


  # メソッド(Private)
end
