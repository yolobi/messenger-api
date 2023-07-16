class User < ApplicationRecord
  # encrypt password
  has_secure_password

  has_many :conversation_members
  has_many :conversations, through: :conversation_members
  has_many :chats
end
