class Post < ApplicationRecord
  # モジュール
  extend Enumerize
  enumerize :category, in: %w(programming university qualification english reading), predicates: { prefix: true }
  
  
  # 関連
  belongs_to :user


  # スコープ
  default_scope -> { order(created_at: :desc) }

  scope :category_filter, -> (category) {
    case category.intern
    when :all
      return
    when :programming
      where(category: 'programming')
    when :university
      where(category: 'university')
    when :qualification
      where(category: 'qualification')
    when :english
      where(category: 'english')
    when :reading
      where(category: 'reading')
    else
      raise "不明のカテゴリ(#{category})"
    end
  }


  # バリデーション
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
