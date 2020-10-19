# == Schema Information
#
# Table name: notices
#
#  id         :bigint           not null, primary key
#  message    :text(65535)      not null
#  note       :text(65535)      not null
#  read_at    :datetime         not null
#  url        :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sender_id  :integer
#  user_id    :integer          not null
#
class Notice < ApplicationRecord
  # モジュール


  # 定数


  # 関連
  belongs_to :user, optional: true
  belongs_to :sender, class_name: 'User', optional: true


  # 委譲
  def user_nickname; user.nickname; end
  def sender_image; sender.image; end


  # スコープ
  scope :with_read, -> { where.not(read_at: nil) } # 既読
  scope :without_read, -> { where(read_at: nil) }  # 未読
  scope :where_before, -> (id) { where('notices.id <= ?', id) }


  # フック


  # バリデーション
  validates :user_id,                 presence: true
                                      # length: { maximum: 255, allow_blank: true }
                                      # uniqueness: false
                                      # format: false
  # validates :sender_id                presence: false
                                      # length: { maximum: 255, allow_blank: true }
                                      # uniqueness: false
                                      # format: false
  validates :message,                 presence: true,
                                      length: { maximum: 1024, allow_blank: true }
                                      # uniqueness: false
                                      # format: false
  validates :url,                     presence: true,
                                      length: { maximum: 2048, allow_blank: true }
                                      # uniqueness: false
                                      # format: false
  # validates :read_at                  presence: false
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
