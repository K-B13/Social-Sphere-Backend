class FriendRequestsController < ApplicationController


  def create
    @friend_request = FriendRequest.new(friend_request_params)
    if @friend_request.save
      render json: @friend_request, status: :created
    else
      render json: @friend_request.errors, status: :unprocessable_entity
    end
  end

  def update
    @friend_request = FriendRequest.find(params[:id])
    if @friend_request.pending?
      if params[:status] == 'accept'
        @friend_request.accept
        render json: { message: 'Friend request accepted'}
      elsif params[:status] == 'reject'
        @friend_request.reject
        render json: { message: 'Friend request rejected' }
      else
        render json: { message: 'Invalid status' }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Friend request has already been accepted or rejected' }, status: :unprocessable_entity
    end
  end

  def destroy
    @friend_request = FriendRequest.find(params[:id])
    @friend_request.destroy
    head :no_content
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:sender_id, :receiver_id, :status)
  end

end
