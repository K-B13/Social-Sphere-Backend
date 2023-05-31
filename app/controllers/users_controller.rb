class UsersController < ApplicationController

  respond_to :json

def index
  @user = current_user

  render json: {
      status: {code: 200, message: 'Logged in sucessfully.'}, data: @user, status: :ok
}
end
end
