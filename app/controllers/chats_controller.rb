class ChatsController < ApplicationController
    before_action :set_conversation, only: [:index]
    before_action :set_message, only: [:create]

    def index
        if @conversation.present?
            @conversation.chats.last.is_read = true
            json_response(format_chats(@conversation.chats), :ok)
        else
            json_response({ error: 'Conversation not found' }, :not_found)
        end
    end

    def create
        receiver = User.find_by(id: params[:user_id])

        conversation = current_user.conversations.
        includes(:conversation_members).
        find_by(conversation_members: {
            user_id: params[:user_id]
        })
        if !conversation.present?
            conversation = Conversation.create()
        end

        conversation.users << [current_user, receiver]

        chat = Chat.create(
            message: @message,
            is_read: false,
            conversation: conversation,
            user: current_user
        )

        json_response(format_response(conversation), :created)
    end

    private

    def set_message
        @message = params[:message]

        return if !@message.blank?
        json_response([], :unprocessable_entity)
    end


    def set_conversation
        @conversation = Conversation.find(params[:conversation_id])

        return if @conversation.users.find_by(id: current_user.id).present?

        json_response({ error: 'This conversation not belong to you' }, :forbidden)
    end

    def format_response(conversation)
        chat = conversation.chats.last
        {
            id: conversation.id,
            message: chat.message,
            sender: format_sender(current_user),
            sent_at: chat.created_at,
            conversation: format_conversation(conversation)
        }
    end

    def format_conversation(conversation)
        other_user = conversation.users.find { |user| user != current_user }
        {
            id: conversation.id,
            with_user: format_user(other_user),
        }
    end

    def format_user(user)
        {
            id: user.id,
            name: user.name,
            photo_url: user.photo_url
        }
    end

    def format_chats(chats)
        chats.map do |chat|
            format_chat(chat)
        end
    end

    def format_chat(chat)
        {
            id: chat.id,
            message: chat.message,
            sender: format_sender(chat.user),
            sent_at: chat.created_at
        }
    end

    def format_sender(sender)
        {
            id: sender.id,
            name: sender.name
        }
    end

end
