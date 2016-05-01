class ApplicationController < ActionController::API
  attr_reader :current_user
  def authenticate
    user  = User.find_by(email: sessions[:email])
    if user && user.active_status
      @current_user = user
    else
      render json: {error: "You need to be logged in first"}, status: unauthorized
    end
  end
end
