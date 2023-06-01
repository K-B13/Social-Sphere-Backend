class UsersController < ApplicationController

  respond_to :json

def index
  @user = current_user

  render json: {
      status: {code: 200, message: 'Here is current user'}, data: @user, status: :ok
}
end
end
