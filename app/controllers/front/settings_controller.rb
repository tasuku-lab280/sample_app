class Front::SettingsController < FrontController
  before_action :authenticate_user!

  # メソッド
  def index
    @notices = current_user.notices.order(created_at: :desc).limit(5)
  end
end
