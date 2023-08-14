class UsersController < ApplicationController
  
  respond_to :json
  require 'fuzzy_match'
  before_action :find_user, only: [:show_user, :update, :retrieve_friends, :all_friends]

  def index
    # Returns all the current users.
    @users = User.all
    render json: {
      status: {code: 200, message: 'Here is a list of all current users'}, data: @users
  } 
  end

  def show_user
    # Returns one users information
    #Grab all the users posts including the likes associated with them and orders them by updated at.
    @posts = @user.posts.includes(:likes)
    @posts = @posts.order(updated_at: :desc)

    @current_user = User.find(params[:user_id])
    
    # Checks to see if the current user and the user in question are friends
    is_friend = @current_user.friends.include?(@user)

    # Gets a sample of 4 friends from the user in questions friend list.
    @lim_friends = @user.friends.limit(4)

    # Checks if there is an outstanding friend request between the two users.
    has_friend_request = @current_user.sent_friend_requests.exists?(receiver: @user) || @user.sent_friend_requests.exists?(receiver: @current_user)

    # Returns all the posts information including the associated like_count and liked_by associated with the posts.
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
    # Updates the given user with the passed down details and returns the updated user details
    @user.update(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def search
    # grabs what the user is looking for and the category they are searching in as well as all the users.
    query = params[:query]
    search_key = params[:search_key]
    users = User.all

    # It then passes the search category and all the users into a new FuzzyMatcher instance.
    fuzzy_matcher = FuzzyMatch.new(users, read: search_key)

    # Then it asks for all instances where the query matches or is similar to what the user is looking for
    search_results = fuzzy_matcher.find_all(query)

    render json: search_results
  end

  def retrieve_friends
    # Grabs all the users and sorts them by when was their last message, sent or received.
    @sorted_friends = user_friends_sorted_by_last_message(@user)
    # selects the first four friends and sends that back
    @lim_friends = @sorted_friends.first(4)
    render json: @lim_friends
  end

  def all_friends
    # Grabs all the users and sorts them by when was their last message, sent or received.
    @sorted_friends = user_friends_sorted_by_last_message(@user)
    render json: {friends: @sorted_friends, user: @user}
  end

  private

  def user_params
    # Used when updating a user's profile
    params.require(:user).permit(:name, :bio, :hometown, :dob, :username)
  end

  def find_user
    # Finds the user
    @user = User.find(params[:id])
  end

  def user_friends_sorted_by_last_message(user)
    friends = user.friends
  
    # Sort the friends based on the timestamp of the last message
    sorted_friends = friends.sort_by do |friend|
      # Find the last message exchanged between the user and the friend
      last_message = Message.where('(user_id = ? AND recipient_id = ?) OR (user_id = ? AND recipient_id = ?)', user.id, friend.id, friend.id, user.id).order(created_at: :desc).first
  
      # Sort by the timestamp of the last message, or a default time if no messages exist
      last_message&.created_at || Time.at(0)
    end
  
    # Reverse the order to have the most recent last messages first
    sorted_friends.reverse
  end
  
end
