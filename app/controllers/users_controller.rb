class UsersController < ApplicationController
	def index

    @users = User.order('created_at')
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(photo_params)
    if @user.save
      flash[:success] = "The photo was added!"
      redirect_to root_path
    else
      render 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
  end

  

  private

  def image_params
    params.require(:user).permit(:image)
  end
  
end
