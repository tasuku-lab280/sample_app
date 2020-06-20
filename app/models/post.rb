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
