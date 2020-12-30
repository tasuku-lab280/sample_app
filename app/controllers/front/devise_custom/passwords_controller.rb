class Front::DeviseCustom::PasswordsController < Devise::PasswordsController
  layout 'front'
  
  before_action :check_guest, only: :create
end
