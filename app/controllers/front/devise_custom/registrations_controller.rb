class Front::DeviseCustom::RegistrationsController < Devise::RegistrationsController
  layout 'front'
  
  before_action :check_guest, only: %i[update destroy]
end
