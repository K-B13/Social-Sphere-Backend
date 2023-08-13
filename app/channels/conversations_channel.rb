class ConversationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversation_#{params[:convo_name]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # def send_message(data)
  #   recipient_id = data['recipient_id']
  #   ActionCable.server.broadcast('conversations_#{recipient_id}', message: data.message )
  # end

  # def typing(data)
  #   recipient_id = data['recipient_id']
  #   ActionCable.server.broadcast("conversations_#{recipient_id}", typing: true)
  # end

  # def stop_typing(data)
  #   recipient_id = data['recipient_id']
  #   ActionCable.server.broadcast("conversations_#{recipient_id}", typing: false)
  # end
end
