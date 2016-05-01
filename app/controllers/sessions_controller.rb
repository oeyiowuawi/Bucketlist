class SessionsController < ApplicationController

  def login
    user = User.find_by_credentials(auth_params)
    if user
      render json: {message: "You have successfully logged in"}, status: 200
    else
      render json: {error: "Invalid username or password"}, status: :unauthorized
    end
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
