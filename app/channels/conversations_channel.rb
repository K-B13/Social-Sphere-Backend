class ConversationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversation_#{params[:convo_name]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
