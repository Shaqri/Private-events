class UsersController < ApplicationController
  include UsersHelper
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:alert] = "User #{@user.name} created successfully"
      redirect_to events_path
    else
      flash.now[:alert] = "Invalid fields"
      render :new
    end
  end

  def show
  end

  private
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
