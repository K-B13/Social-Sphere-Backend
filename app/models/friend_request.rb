class FriendRequest < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  validate :not_self_request
  validate :not_duplicate_request

  def not_self_request
    errors.add(:base, "Cannot send friend request to yourself") if sender == receiver
  end
  
  def not_duplicate_request
    if FriendRequest.exists?(sender: sender, receiver: receiver, status: :pending)
    errors.add(:base, "Friend request already sent")
    elsif FriendRequest.exists?(sender: receiver, receiver: sender, status: :pending)
      errors.add(:base, "You already have a pending friend request from this user")
    end
  end

  def accept
    Friendship.transaction do
      Friendship.create(user: sender, friend: receiver)
      update(status: :accepted)
      destroy
    end
  end

  def reject
    update(status: :rejected)
    destroy
  end

end
