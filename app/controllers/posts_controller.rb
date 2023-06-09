class PostsController < ApplicationController

  before_action :find_user
  before_action :find_post, only: [:update, :destroy]
  before_action :get_all_posts
  respond_to :json

  def index
    # Grabs all the posts for a specific user.
    @posts = @user.posts.includes(:likes)
    # Sorts the posts by their data.
    @sorted_posts = @posts.order(updated_at: :desc)
    render json: {
      status: {
        code: 200, 
        message: 'Here are all the posts'}, 
      data: {
        userPosts: serialize_posts(@sorted_posts), 
        posts: serialize_posts(@user_and_friends_posts)
      }, status: :ok
}
  end

  def create
    # Creates a new post for a given user with the information passed from the user.
    @post = @user.posts.new(post_params)
    # Makes the author of the post the user the post is associated with.
    @post.author = @user.username
    # If the post can save return the information else return error.
    if @post.save
      @sorted_posts = @user.posts.includes(:likes).order(updated_at: :desc)
      render json: {
        userPosts: serialize_posts(@sorted_posts), 
        posts: serialize_posts(@user_and_friends_posts) 
        }, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    # Update a post with the given information and if it can save send it back else send error
    @post.update(post_params)
    if @post.save
      @sorted_posts = @user.posts.includes(:likes).order(updated_at: :desc)
      render json: {
        userPosts: serialize_posts(@sorted_posts), 
        posts: serialize_posts(@user_and_friends_posts) 
      }, 
        status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
      @post.destroy
      if @post
        @sorted_posts = @user.posts.includes(:likes).order(updated_at: :desc)
        render json: {
          userPosts: serialize_posts(@sorted_posts), 
          posts: serialize_posts(@user_and_friends_posts)
        }, 
          status: :ok
      else
        render json: @post.errors, status: :unprocessable_entity
      end
  end

  def homepage
    
    render json: { 
      user: @user, 
      posts: serialize_posts(@user_and_friends_posts) }
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_post
    @post = @user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content)
  end

  def get_all_posts
    # 'Plucks' all the friend id's from a user and stores them in an array.
    @friend_ids = @user.friends.pluck(:id)
    # Gets all the user posts and friends posts based on their ids and 'flattens' them so they are in an array on the same level.
    @user_and_friends_posts = Post.where(user_id: [@friend_ids, @user.id].flatten).order(updated_at: :desc)
  end

  def serialize_posts(posts)
    # Expands what is sent back to include likes and liked by associated with the posts/
    posts.map do |post|
      {
        id: post.id,
        content: post.content,
        like_count: post.likes_count,
        liked_by: post.liked_by,
        updated_at: post.updated_at,
        user_id: post.user_id,
        author: post.author
      }
    end
  end
end
