class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  # after a Friendship is created an inverse friendship is also created meaning that the friendship is mutual
  after_create :create_inverse_friendship
  #after a friendship is destroyed the inverse friendship is also destroyed
  after_destroy :destroy_inverse_friendship

  private

  def create_inverse_friendship
    # finds a record in the friendships table or collection that belongs to the friend and has a friend attribute matching the user.
    existing_inverse_friendship = friend.friendships.find_by(friend: user)
    return if existing_inverse_friendship.present?
    # creates a new friendship.
    friend.friendships.create(user: friend, friend: user)
  end

  def destroy_inverse_friendship
    #finds the record where the friend is friends with the user and also destroys it.
    inverse_friendship = friend.friendships.find_by(friend: user)
    inverse_friendship.destroy if inverse_friendship.present?
  end

end
