class HomesController < ApplicationController
  def index
    @categories = Category.includes(:items).first(4)
  end
end
