class Conversation < ApplicationRecord
    has_many :conversation_members
    has_many :users, through: :conversation_members

    has_many :chats
end
