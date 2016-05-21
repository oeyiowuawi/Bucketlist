module AuthHelpers
  def check_logged_in
    render(
      json: { error: messages.must_be_logged_in },
      status: 401) unless current_user.active_status
  end

  def user_id_included_in_auth_token?
    http_auth_token && decoded_auth_token[:user_id]
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
    render json: { errors: messages.expired_token }, status: 401
  end

  def user_not_authenticated
    render(
      json: { errors: messages.not_authenticated },
      status: :unauthorized
    )
  end
end
