class Message < ApplicationRecord
  belongs_to :user
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id' 
end
