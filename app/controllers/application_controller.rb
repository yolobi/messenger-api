class ApplicationController < ActionController::API
    include Response
    include ExceptionHandler

    before_action :authorize_request
    attr_reader :current_user

    private

    def authorize_request
        @current_user = decode_jwt_token
        render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    end

    def decode_jwt_token
        authorization_header = request.headers['Authorization']
        token = authorization_header.split(' ').last if authorization_header.present?

        return unless token

        decoded_token = JsonWebToken.decode(token)
        user_id = decoded_token[:user_id]
        User.find(user_id) if user_id
    rescue JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature
        nil
    end
end
