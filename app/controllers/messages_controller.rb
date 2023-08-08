class MessagesController < ApplicationController

  before_action :find_user  
  
  def index
    # User is found and stored in the id @user before this actions starts
    # Then the other user is found so the messages between the two can be found.
    # got_messages = @user.received_messages.find_by(user_id: friend_user.id)
    # sent_messages = @user.sent_messages
    # render json: {messagesSent: sent_messages , messagesReceived: got_messages}
  end

  def show

  end

  def create
    # Create the message and save it to the database
    message = Message.create(message_params)

    # Broadcast the message to both users' ConversationChannel
    ConversationChannel.broadcast_to(message.user, message: message.content, user: message.user.username)
    ConversationChannel.broadcast_to(message.recipient, message: message.content, user: message.user.username)
  end

  def update

  end

  def destroy
  
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def message_params
    params.require(:message).permit(:content, :user_id, :recipient)
  end
end
