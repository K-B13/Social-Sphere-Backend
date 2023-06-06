class PostsController < ApplicationController

  before_action :find_user
  before_action :find_post, only: [:update, :destroy]
  before_action :get_all_posts
  respond_to :json

  def index
    @posts = @user.posts.includes(:likes)
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
    @post = @user.posts.new(post_params)
    @post.author = @user.username
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
    # @friend_ids = @user.friends.pluck(:id)
    # @user_and_friends_posts = Post.where(user_id: [@friend_ids, @user.id].flatten).order(updated_at: :desc)
    
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
    @friend_ids = @user.friends.pluck(:id)
    @user_and_friends_posts = Post.where(user_id: [@friend_ids, @user.id].flatten).order(updated_at: :desc)
  end

  def serialize_posts(posts)
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
