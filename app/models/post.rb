# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  category   :string(255)      not null
#  content    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_user_id                 (user_id)
#  index_posts_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  # モジュール
  extend Enumerize
  enumerize :category, in: %w(programming university qualification english reading), predicates: { prefix: true }, scope: true
  
  
  # 関連
  belongs_to :user


  # スコープ


  # バリデーション
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
