class PostsController < ApplicationController

  before_action :find_user
  before_action :find_post, only: [:update, :destroy]
  before_action :get_all_posts
  respond_to :json

  def index
    @posts = @user.posts
    @posts = @posts.sort {|a, b|  b.updated_at <=> a.updated_at }
    render json: {
      status: {code: 200, message: 'Here are all the posts'}, data: {userPosts: @posts, posts: @user_and_friends_posts}, status: :ok
}
  end

  def create
    @post = @user.posts.new(post_params)
    @post.author = @user.username
    if @post.save
      @sorted_posts = @user.posts.sort {|a, b|  b.updated_at <=> a.updated_at }
      render json: {userPosts: @sorted_posts, posts: @user_and_friends_posts }, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    @post.update(post_params)
    if @post.save
      @sorted_posts = @user.posts.sort {|a, b|  b.updated_at <=> a.updated_at }
      render json: {userPosts: @sorted_posts, posts: @user_and_friends_posts }, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
      @post.destroy
      if @post
        @sorted_posts = @user.posts.sort {|a, b|  b.updated_at <=> a.updated_at }
        render json: {userPosts: @sorted_posts, posts: @user_and_friends_posts }, status: :ok
      else
        render json: @post.errors, status: :unprocessable_entity
      end
  end

  def homepage
    # @friend_ids = @user.friends.pluck(:id)
    # @user_and_friends_posts = Post.where(user_id: [@friend_ids, @user.id].flatten).order(updated_at: :desc)
    
    render json: { user: @user, posts: @user_and_friends_posts }
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
end
