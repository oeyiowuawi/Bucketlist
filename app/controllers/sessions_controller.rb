class SessionsController < ApplicationController
  before_action :authenticate, only: :destroy
  def login
    user = User.find_by_credentials(auth_params)
    if user
      session[:email] = auth_params[:email]
      render json: authentication_payload(user), status: 200
    else
      render json: {error: "Invalid username or password"}, status: :unauthorized
    end
  end

  def destroy
    binding.pry
    current_user.update_attribute('active_status', false)
    session[:email] = nil
    render json: {message: "You have been logged out"}, status: :success
  end

  private

  def auth_params
    params.permit(:email, :password)
  end

  def authentication_payload(user)
    {auth_token: AuthToken.encode({user_id: user.id})}
  end
end
