require 'rails_helper'

RSpec.describe SessionsController, type: :request do


  describe "when user tries to login" do
    let (:user) do
      create(:user)
    end
    let(:invalid_password) {"1234567"}

    it "with valid credential" do
      post "/auth/login", {
        email: user.email,
        password: user.password
      }
      expect(response).to have_http_status 200
      expect(json["auth_token"]).to be_truthy
    end

    it "with invalid credential" do

      post "/auth/login", {
        email: user.email,
        password: invalid_password
      }
      expect(response).to have_http_status :unauthorized
      expect(json["error"]).to eq "Invalid username or password"
    end

  end

  describe "log out" do
    let (:user) do
      create(:user)
    end
    it "allows logged in users to log out" do

      headers = {"HTTP_AUTHORIZATION" => token_generator(user)}
      get '/auth/logout',{}, headers
      expect(response).to have_http_status 200
      expect(json["message"]).to eq "You have been logged out"
    end
    it "tells non-logged in users to login first" do
      get '/auth/logout'
      expect(json["errors"]).to eq "Not Authenticated"
    end
  end
end
