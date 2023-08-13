class MessagesController < ApplicationController

  before_action :authenticate_user!
  
  def index
    @recipient_id = params[:user_id]
    @messages = Message.where("(user_id = ? AND recipient_id = ?) OR (user_id = ? AND recipient_id = ?)", current_user.id, @recipient_id, @recipient_id, current_user.id).order(created_at: :asc)

    render json: @messages
  end

  def show

  end

  def create
    @recipient_id = params[:user_id]
    @message = current_user.sent_messages.new(message_params)
    @message.recipient_id = @recipient_id
    @message.user_id = current_user.id
    if @message.save
    ActionCable.server.broadcast("conversation_#{@recipient_id}", @message)
    ActionCable.server.broadcast("conversation_#{current_user.id}", @message)
    render json: {message: @message}
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def update

  end

  def destroy
  
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
