class Api::UsersController < ApplicationController
  def create
    user = User.new(users_params)
    if user.save

      render json: user, status: 201, location: users_path(user)
    else
      render json: {errors: user.errors}, status: 422
    end
  end

  private
  def users_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
