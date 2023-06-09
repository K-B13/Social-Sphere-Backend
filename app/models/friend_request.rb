class FriendRequest < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  validate :not_self_request
  validate :not_duplicate_request


  # Prevents users sending requests to themselves
  def not_self_request
    errors.add(:base, "Cannot send friend request to yourself") if sender == receiver
  end
  
  # Check to see if there is an outstanding request pending either sent by the user or received by the user.
  def not_duplicate_request
    if FriendRequest.exists?(sender: sender, receiver: receiver, status: :pending)
    errors.add(:base, "Friend request already sent")
    elsif FriendRequest.exists?(sender: receiver, receiver: sender, status: :pending)
      errors.add(:base, "You already have a pending friend request from this user")
    end
  end

  # Creates a new friendship between the sender and the receiver. The request is then destroyed.
  def accept
    Friendship.transaction do
      Friendship.create(user: sender, friend: receiver)
      update(status: :accepted)
      destroy
    end
  end

  # Destroyed a friend request on its rejecting by a user.
  def reject
    update(status: :rejected)
    destroy
  end

end
