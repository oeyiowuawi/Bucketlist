class Api::SessionsController < ApplicationController
  before_action :authenticate, only: :destroy
  def login
    user = User.find_by_credentials(auth_params)
    if user
      render json: authentication_payload(user), status: 200
    else
      render json: {error: "Invalid username or password"}, status: :unauthorized
    end
  end

  def destroy
    current_user.update_attribute('active_status', false)
    render json: {message: "You have been logged out"}, status: 200
  end

  private

  def auth_params
    params.permit(:email, :password)
  end

  def authentication_payload(user)
    {auth_token: AuthToken.encode({user_id: user.id})}
  end
end
