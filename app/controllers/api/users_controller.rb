module Api
  class UsersController < ApplicationController
    def create
      user = User.new(users_params)
      if user.save
        response = { user: UserSerializer.new(user) }.merge!(
          user.authentication_payload
        )
        render(
          json: response,
          status: 201,
          location: api_users_path(user),
          root: false
        )
      else
        render json: { errors: user.errors }, status: 422
      end
    end

    private

    def users_params
      params.permit(
        :name,
        :email,
        :password,
        :password_confirmation
      )
    end
  end
end
