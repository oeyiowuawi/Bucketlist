module Api
  class SessionsController < ApplicationController
    before_action :authenticate, only: :destroy
    def login
      user = User.find_by_credentials(auth_params)
      if user
        render json: user.authentication_payload, status: 200
      else
        render json: { error: "Invalid username or password" },
               status: :unauthorized
      end
    end

    def destroy
      current_user.update_attribute("active_status", false)
      render json: { message: "You have been logged out" }, status: 200
    end

    private

    def auth_params
      params.permit(:email, :password)
    end
  end
end
