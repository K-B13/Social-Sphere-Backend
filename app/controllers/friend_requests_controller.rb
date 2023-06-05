class FriendRequestsController < ApplicationController

  before_action :find_friend_request, only: [:destroy, :update]
  before_action :find_user, only: [:all_sent]

  def all_sent
    sent_requests = @user.sent_friend_requests.includes(:receiver)
    received_requests = @user.received_friend_requests.includes(:sender)
    render json: {
      sentRequests: sent_requests.as_json(include: { receiver: { only: [:name, :username] }}), 
      receivedRequests: received_requests.as_json(include: { sender: { only: [:name, :username] }}),
      user: @user.id
    }
  end

  def create
    @friend_request = FriendRequest.new(friend_request_params)
    if @friend_request.save
      render json: @friend_request, status: :created
    else
      render json: @friend_request.errors, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:user_id])

    sent_requests = @user.sent_friend_requests.includes(:receiver)

    received_requests = @user.received_friend_requests.includes(:sender)

    if @friend_request.pending?
      if params[:status] == 'accept'
        @friend_request.accept
        render json: {
          sentRequests: sent_requests.as_json(include: { receiver: { only: [:name, :username] }}), 
          receivedRequests: received_requests.as_json(include: { sender: { only: [:name, :username] }}),
          user: @user.id
        }
      elsif params[:status] == 'reject'
        @friend_request.reject
        render json: {
          sentRequests: sent_requests.as_json(include: { receiver: { only: [:name, :username] }}), 
          receivedRequests: received_requests.as_json(include: { sender: { only: [:name, :username] }}),
          user: @user.id
        }
      else
        render json: { message: 'Invalid status' }, status: :unprocessable_entity
      end
      
    else
      render json: { message: 'Friend request has already been accepted or rejected' }, status: :unprocessable_entity
    end
  end

  def destroy
    @friend_request.destroy
    head :no_content
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:sender_id, :receiver_id, :status)
  end

  def find_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end

  def find_user
    @user = User.find(params[:id])
  end
end
