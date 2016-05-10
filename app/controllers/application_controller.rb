class ApplicationController < ActionController::API
  include ActionController::Serialization

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

  private

  def check_logged_in
    render json: { error: "You must be logged in to access this resource " },
           status: 401 unless current_user.active_status
  end

  def user_id_included_in_auth_token?
    http_auth_token && decoded_auth_token && decoded_auth_token[:user_id]
  end

  def decoded_auth_token
    @decoded_auth_token ||= AuthToken.decode(http_auth_token)
  end

  def http_auth_token
    @http_auth_token ||= if request.headers["Authorization"].present?
                           request.headers["Authorization"].split(" ").last
                         end
  end

  def authentication_timeout
    render json: { errors: "Expired Token" }, status: 401
  end

  def user_not_authenticated
    render json: { errors: "Not Authenticated. invalid or missing token" },
           status: :unauthorized
  end
end
