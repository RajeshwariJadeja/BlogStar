class ApplicationController < ActionController::Base
  protect_from_forgery
  def home
  	redirect_to home
  end
end
