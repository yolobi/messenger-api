module ControllerSpecHelper
  # generate tokens from user id
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  # generate expired tokens from user id
  def expired_token_generator(user_id)
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end

  # return valid headers
  def valid_headers(user_id)
    {
      "Authorization" => token_generator(user_id),
      # "Content-Type" => "application/json"
      # https://stackoverflow.com/questions/49053954/testing-post-actiondispatchhttpparametersparseerror-765
      # comment this because its caused
      # ActionDispatch::Http::Parameters::ParseError:
      # 783: unexpected token at 'message=&user_id=11'
    }
  end

  # return invalid headers
  def invalid_headers
    {
      "Authorization" => nil,
      "Content-Type" => "application/json"
    }
  end
end
