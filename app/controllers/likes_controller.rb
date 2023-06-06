class LikesController < ApplicationController
  before_action :set_likeable, only: [:create]

  def create 
    like = @likeable.likes.build(user: current_user)

    if like.save
      render json: {
        like_count: @likeable.likes.count,
        liked_by: @likeable.likes.map { |like| like.user.username}
      }
    else
      render json: { error: like.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy 
    like = Like.find(params[:id])
    resource = like.likeable

    if like.destroy
      render json: {
        like_count: resource.likes.count,
        liked_by: resource.likes.map { |like| like.user.username }
    }
    else
      render json: { error: like.errors.full_messages }, status: :unprocessable_entity
    end
  end

    private

  def set_likeable
    if params[:post_id]
      @likeable = Post.find(params[:post_id])
    elsif params[:comment_id]
      @likeable = Comment.find(params[:comment_id])
    end
  end

end
