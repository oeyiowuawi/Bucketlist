class ApplicationController < ActionController::API
  include ActionController::Serialization

  rescue_from Api::AuthenticationTimeoutError, with: :authentication_timeout
  rescue_from Api::NotAuthenticatedError, with: :user_not_authenticated

  attr_reader :current_user
  def authenticate
    raise Api::NotAuthenticatedError unless user_id_included_in_auth_token?
    @current_user = User.find(decoded_auth_token[:user_id])
    check_logged_in
  rescue JWT::ExpiredSignature
    raise Api::AuthenticationTimeoutError
  rescue JWT::VerificationError, JWT::DecodeError
    raise Api::NotAuthenticatedError
  end

  private

  def check_logged_in
    render json: { mesage: "You must be logged in to access this resource " },
           status: 419 unless @current_user.active_status
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
    render json: { errors: "Authentication Timeout" }, status: 419
  end

  def forbidden_resource
    render json: { errors: ["Not Authorized To Access Resource"] },
           status: :forbidden
  end

  def user_not_authenticated
    render json: { errors: "Not Authenticated" }, status: :unauthorized
  end
end
