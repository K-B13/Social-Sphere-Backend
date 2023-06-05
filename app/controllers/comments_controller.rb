class CommentsController < ApplicationController

  before_action :find_user
  before_action :find_post
  before_action :find_comment, only: [:update, :destroy]

  def index
    @comments = @post.comments
    @comments = @comments.sort {|a, b|  b.updated_at <=> a.updated_at }
    render json: {
      status: {code: 200, message: 'Here are all comments'}, data: @comments, status: :ok
}
  end

  def create_comment
    @comment = @post.comments.new(comment_params)
    @comment.user_id = @user.id
    @comment.author = User.find(params[:id]).username
    if @comment.save
      @sorted_comments = @post.comments.sort {|a, b| b.updated_at <=> a.updated_at }
      render json: @sorted_comments, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    @comment.update(comment_params)
    if @comment.save
      @sorted_comments = @post.comments.sort {|a, b| b.updated_at <=> a.updated_at }
      render json: @sorted_comments, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    if @comment
      @sorted_comments = @post.comments.sort {|a, b| b.updated_at <=> a.updated_at }
      render json: @sorted_comments, status: :ok
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
