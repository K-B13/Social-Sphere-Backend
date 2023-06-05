class FriendshipsController < ApplicationController

  def create
    @friendship = Friendship.new(friendship_params)

    if friendship.save
      render json: @friendship, status: :created
    else
      render json: @friendship.errors, status: :unprocessable_entity
    end
  end

  def destroy
    current_user = User.find(params[:current_user_id])
    friend_user = User.find(params[:friend_user_id])
    @friendship = current_user.friendships.find_by(friend_id: friend_user.id)
    
    if @friendship
      @friendship.destroy
      head :no_content
    else
      head :not_found
    end
  end

  private

  def friendship_params
    params.require(:friendship).permit(:user_id, :friend_id)
  end

end
