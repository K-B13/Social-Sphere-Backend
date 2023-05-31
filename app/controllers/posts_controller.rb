class PostsController < ApplicationController

  respond_to :json

  def index
    @user = User.find(params[:user_id])
    @posts = @user.posts
    render json: {
      status: {code: 200, message: 'Logged in sucessfully.'}, data: @posts, status: :ok
}
  end

  def create
    @user = User.find(params[:user_id])
    post = @user.posts.new(post_params)
    post.author = @user.email

    if post.save
      render json: post, status: :created
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:user_id])
    post = @user.posts.find(params[:id])
    post.update(post_params)

    if post.save
      render json: post, status: :created
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  def destroy
      @user = User.find(params[:user_id])
      post = @user.posts.find(params[:id])
      post.destroy
      if post
        render json: 'Post destroyed', status: :ok
      else
        render json: post.errors, status: :unprocessable_entity
      end
  end



  private

  def post_params
    params.require(:post).permit(:content)
  end
end
