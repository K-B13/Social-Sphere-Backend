class CommentsController < ApplicationController

  before_action :find_user
  before_action :find_post
  before_action :find_comment, only: [:update, :destroy]

  def index
    @comments = @post.comments
    render json: {
      status: {code: 200, message: 'Here are all comments'}, data: @comments, status: :ok
}
  end

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user_id = @user.id
    @comment.author = @user.email
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    @comment.update(comment_params)
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    if @comment
      render json: 'Comment destroyed', status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_post
    @post = @user.posts.find(params[:post_id])
  end

  def find_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
