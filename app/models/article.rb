# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  note       :text(65535)
#  status     :string(255)      not null
#  title      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
class Article < ApplicationRecord
  # モジュール
  extend Enumerize
  enumerize :status, in: %w(public draft private), predicates: { prefix: true }, scope: true


  # 定数
  
  
  # 関連
  belongs_to :user


  # 委譲


  # スコープ
  scope :front_default, -> { where(status: :public) }


  # フック


  # バリデーション
  validates :user_id,             presence: true
                                  # length: { maximum: 255 },
                                  # uniqueness: true
                                  # format: false
  validates :status,              presence: true,
                                  length: { maximum: 255 }
                                  # uniqueness: false
                                  # format: false
  validates :title,               presence: true,
                                  length: { maximum: 255 }
                                  # uniqueness: { scope: :group_id }
                                  # format: false                                                                
  validates :body,                presence: true,
                                  length: { maximum: 65535 }
                                  # uniqueness: { scope: :group_id }
                                  # format: false       
  validates :note,                # presence: false
                                  length: { maximum: 1024 }
                                  # uniqueness: { scope: :group_id }
                                  # format: false
end
