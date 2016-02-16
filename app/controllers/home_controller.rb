class HomeController < ApplicationController
	def home
  	
  end
  def create
  	@user = User.create( params[:user] )
	end
end
