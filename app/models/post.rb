class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  def likes_count
    likes.count
  end

  def liked_by
    likes.map { |like| like.user.username }
  end
end
