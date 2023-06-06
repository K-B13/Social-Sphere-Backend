class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_many :posts, dependent: :destroy
  has_many :comments, through: :posts
  has_many :likes, dependent: :destroy

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  has_many :sent_friend_requests, class_name: 'FriendRequest', foreign_key: 'sender_id', dependent: :destroy

  has_many :received_friend_requests, class_name: 'FriendRequest', foreign_key: 'receiver_id', dependent: :destroy

  before_destroy :cleanup_friend_requests
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  validates :username, presence: true, uniqueness: true

  private
  def cleanup_friend_requests
    sent_friend_requests.destroy_all
    received_friend_requests.destroy_all
  end

end
