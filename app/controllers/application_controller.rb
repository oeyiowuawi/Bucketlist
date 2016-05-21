class ApplicationController < ActionController::API
  include ActionController::Serialization
  include AuthHelpers

  rescue_from AuthenticationTimeoutError, with: :authentication_timeout
  rescue_from NotAuthenticatedError, with: :user_not_authenticated

  attr_reader :current_user

  def authenticate
    fail NotAuthenticatedError unless user_id_included_in_auth_token?
    @current_user = User.find(decoded_auth_token[:user_id])
    check_logged_in
  rescue JWT::ExpiredSignature
    raise AuthenticationTimeoutError
  rescue JWT::VerificationError, JWT::DecodeError
    raise NotAuthenticatedError
  end

  def invalid_endpoint
    render(
      json: { error: messages.invalid_endpoint },
      status: 404
    )
  end

  def messages
    Messages.new
  end
end
