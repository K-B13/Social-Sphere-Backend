class UsersController < ApplicationController
  
  respond_to :json
  require 'fuzzy_match'
  before_action :find_user, only: [:show_user, :update, :retrieve_friends]

  def index
    @users = User.all
    render json: {
      status: {code: 200, message: 'Here is a list of all current users'}, data: @users
  } 
  end

  def show_user
    @posts = @user.posts
    @current_user = User.find(params[:user_id])
    is_friend = @current_user.friends.include?(@user)
    @lim_friends = @user.friends.limit(5)

    has_friend_request = @current_user.sent_friend_requests.exists?(receiver: @user)
    
    render json: {user: @user, posts: @posts, isFriend: is_friend, hasFriendRequest: has_friend_request, currentUser: @current_user, friends: @lim_friends}
  end

  def update
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

  def retrieve_friends
    @lim_friends = @user.friends.limit(5)
    render json: @lim_friends
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :bio, :hometown, :dob, :username)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
