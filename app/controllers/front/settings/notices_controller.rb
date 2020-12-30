class Front::Settings::NoticesController < Front::SettingsController
  # 定数
  INDEX_PER_WORKS = 50


  # メソッド
  def index
    @notices = current_user.notices
             .page(params[:page]).per(params[:per_page] || INDEX_PER_WORKS)
             .order(created_at: :desc)
  end
end
