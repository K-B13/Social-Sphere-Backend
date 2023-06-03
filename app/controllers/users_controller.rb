class UsersController < ApplicationController
  

  respond_to :json
  require 'fuzzy_match'

  def index
    @users = User.all
    render json: {
      status: {code: 200, message: 'Here is current user'}, data: @users
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

  def search
    query = params[:query]
    search_key = params[:search_key]
    users = User.all

    fuzzy_matcher = FuzzyMatch.new(users, read: search_key)
    search_results = fuzzy_matcher.find_all(query)

    render json: search_results
  end

  private
  def user_params
    params.require(:user).permit(:name, :bio, :hometown, :dob, :username)
  end
end
