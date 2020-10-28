class Front::SettingsController < FrontController
  before_action :authenticate_user!

  def index
  end
end
