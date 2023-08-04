class MessagesController < ApplicationController

  before_action :find_user  
  
  def index
    # User is found and stored in the id @user before this actions starts
    # Then the other user is found so the messages between the two can be found.
    got_messages = @user.received_messages.find_by(user_id: friend_user.id)
    sent_messages = @user.sent_messages
    render json: {messagesSent: sent_messages , messagesReceived: got_messages}
  end

  def show

  end

  def create

  end

  def update

  end

  def destroy
  
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

end
