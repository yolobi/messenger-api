class ConversationsController < ApplicationController
    before_action :set_conversation, only: [:show]

    def index
        conversations = current_user.conversations
        json_response(format_conversations(conversations), :ok)
    end

    def show
        if @conversation.present?
            json_response(format_conversation(@conversation), :ok)
        else
            json_response({ error: 'Conversation not found' }, :not_found)
        end
    end

    private

    def set_conversation
        @conversation = Conversation.find(params[:id])

        return if @conversation.users.find_by(id: current_user.id).present?

        json_response({ error: 'This conversation not belong to you' }, :forbidden)
    end

    def format_conversations(conversations)
        conversations.map do |conversation|
            format_conversation(conversation)
        end
    end

    def format_conversation(conversation)
        other_user = conversation.users.find { |user| user != current_user }
        unread_count = conversation.chats.where(is_read: false).count

        {
            id: conversation.id,
            with_user: format_user(other_user),
            last_message: format_last_message(conversation),
            unread_count: unread_count
        }
    end


    def format_user(user)
        {
            id: user.id,
            name: user.name,
            photo_url: user.photo_url
        }
    end

    def format_last_message(conversation)
        last_chat = conversation.chats.last

        if last_chat.present?
            {
                id: last_chat.id,
                sender: format_user(last_chat.user),
                sent_at: last_chat.created_at.to_s
            }
        else
            nil
        end
    end
  end
