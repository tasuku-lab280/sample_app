class FrontMemberController < FrontController
  before_action :authenticate_user!
end
