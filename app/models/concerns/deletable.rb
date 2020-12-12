module Deletable
  extend ActiveSupport::Concern

  included do
    # スコープ
    scope :without_deleted, -> { where(deleted_at: nil) }
    scope :only_deleted, -> { where.not(deleted_at: nil) }

    # バリデーション
    validates :deleted_at,          presence: false
                                    # uniqueness: false
                                    # length: { maximum: 255 }
                                    # format: false
  end
end
