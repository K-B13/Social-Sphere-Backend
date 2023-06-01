class PostsController < ApplicationController

  before_action :find_user
  before_action :find_post, only: [:update, :destroy]
  respond_to :json

  def index
    @posts = @user.posts
    render json: {
      status: {code: 200, message: 'Here are all the posts'}, data: @posts, status: :ok
}
  end

  def create
    @post = @user.posts.new(post_params)
    @post.author = @user.email
    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    @post.update(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
      @post.destroy
      if @post
        render json: 'Post destroyed', status: :ok
      else
        render json: @post.errors, status: :unprocessable_entity
      end
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
end
