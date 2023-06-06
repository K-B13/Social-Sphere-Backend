class CommentsController < ApplicationController

  before_action :find_user
  before_action :find_post
  before_action :find_comment, only: [:update, :destroy]
  before_action :load_comments

  def index
    serialize_comments
    render json: {
      status: {
        code: 200, 
        message: 'Here are all comments'}, 
      data: @serialized_comments, 
      status: :ok
}
  end

  def create_comment
    @comment = @post.comments.new(comment_params)
    @comment.user_id = @user.id
    @comment.author = User.find(params[:id]).username

    if @comment.save
      serialize_comments
      render json: @serialized_comments, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    @comment.update(comment_params)
    if @comment.save
      serialize_comments
      render json: @serialized_comments, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    if @comment
      serialize_comments
      render json: @serialized_comments, status: :ok
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

  def load_comments
    @comments = @post.comments.order(updated_at: :desc)
  end

  def serialize_comments
    @serialized_comments = @comments.map do |comment|
      {
        id: comment.id,
        content: comment.content,
        author: comment.author,
        updated_at: comment.updated_at,
        like_count: comment.likes.count,
        liked_by: comment.likes.map { |like| like.user.username },
        user_id: comment.user_id,
        post_id: comment.post_id
      }
    end
  end
end
