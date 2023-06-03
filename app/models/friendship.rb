class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  after_create :create_inverse_friendship
  after_destroy :destroy_inverse_friendship

  private

  def create_inverse_friendship
    existing_inverse_friendship = friend.friendships.find_by(friend: user)
    return if existing_inverse_friendship.present?

    friend.friendships.create(user: friend, friend: user)
  end

  def destroy_inverse_friendship
  inverse_friendship = friend.friendships.find_by(friend: user)
  inverse_friendship.destroy if inverse_friendship.present?
  end

end
