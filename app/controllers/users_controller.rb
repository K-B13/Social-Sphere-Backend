class UsersController < ApplicationController

  respond_to :json

  def index
    @users = User.all
    render json: {
      status: {code: 200, message: 'Here is current user'}, data: @users, status: :ok
  } 
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :bio, :hometown, :dob, :username)
  end
end
