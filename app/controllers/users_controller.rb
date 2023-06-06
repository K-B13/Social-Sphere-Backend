class UsersController < ApplicationController
  
  respond_to :json
  require 'fuzzy_match'
  before_action :find_user, only: [:show_user, :update, :retrieve_friends, :all_friends]

  def index
    @users = User.all
    render json: {
      status: {code: 200, message: 'Here is a list of all current users'}, data: @users
  } 
  end

  def show_user
    @posts = @user.posts.includes(:likes)
    @posts = @posts.order(updated_at: :desc)

    @current_user = User.find(params[:user_id])
    is_friend = @current_user.friends.include?(@user)
    @lim_friends = @user.friends.limit(5)

    has_friend_request = @current_user.sent_friend_requests.exists?(receiver: @user) || @user.sent_friend_requests.exists?(receiver: @current_user)

    @serialized_posts = @posts.map do |post|
      {
        id: post.id,
        content: post.content,
        updated_at: post.updated_at,
        like_count: post.likes.count,
        liked_by: post.likes.map { |like| like.user.username },
        author: post.author,
        user_id: post.user_id
      }
    end
    
    render json: {
      user: @user, 
      posts: @serialized_posts, 
      isFriend: is_friend, 
      hasFriendRequest: has_friend_request, 
      currentUser: @current_user, 
      friends: @lim_friends}
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

  def all_friends
    @friends = @user.friends
    render json: {friends: @friends, user: @user}
  end

  private

  def user_params
    params.require(:user).permit(:name, :bio, :hometown, :dob, :username)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
