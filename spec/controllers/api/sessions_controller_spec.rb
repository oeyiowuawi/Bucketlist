require "rails_helper"

RSpec.describe Api::SessionsController, type: :request do
  before(:all) do
    @user = create(:user)
  end
  describe "when user tries to login" do
    let(:invalid_password) { "1234567" }

    it "with valid credential" do
      header = {
        "Content-Type" => "application/json",
        "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
      }
      post "/auth/login", {
        email: @user.email,
        password: @user.password }.to_json, header
      expect(response).to have_http_status 200
      expect(json["auth_token"]).to be_truthy
    end

    it "with invalid credential" do
      header = {
        "Content-Type" => "application/json",
        "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
      }
      post "/auth/login", {
        email: @user.email,
        password: invalid_password }.to_json, header

      expect(response).to have_http_status :unauthorized
      expect(json["error"]).to eq "Invalid username or password"
    end
  end

  describe "log out" do
    it "allows logged in users to log out" do
      headers = {
        "HTTP_AUTHORIZATION" => token_generator(@user),
        "Content-Type" => "application/json",
        "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
      }
      get "/auth/logout", {}, headers
      expect(response).to have_http_status 200
      expect(json["message"]).to eq "You have been logged out"
    end
    it "tells non-logged in users to login first" do
      headers = {
        "Content-Type" => "application/json",
        "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
      }

      get "/auth/logout", {}, headers
      expect(json["errors"]).to include "Not Authenticated"
    end
  end

  describe "Non-logged in user with valid token" do
    before(:all) do
      token = token_generator(@user)
      headers = {
        "HTTP_AUTHORIZATION" => token,
        "Content-Type" => "application/json",
        "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
      }
      get "/auth/logout", {}, headers

      get "/bucketlists", {}, "HTTP_AUTHORIZATION" => token,
                              "Content-Type" => "application/json",
                              "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
    end

    it " returns a status code of 401" do
      expect(response).to have_http_status 401
    end
    it " returns an error message " do
      expect(json["error"]).to include "You must be logged in"
    end
  end

  describe "Expired Token" do
    before(:all) do
      user = create(:user, active_status: true)
      token = AuthToken.encode({ user_id: user.id }, 0.0333333)
      sleep 5
      headers = {
        "HTTP_AUTHORIZATION" => token,
        "Content-Type" => "application/json",
        "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
      }
      get "/bucketlists", {}, headers
    end
    it "returns a status code of 401" do
      expect(response).to have_http_status 401
    end
    it "returns the appropriate error message" do
      expect(json["errors"]).to eq "Expired Token"
    end
  end
  describe "Invalid Token" do
    before(:all) do
      user = create(:user)
      token = token_generator(user) << "invalid"
      headers = {
        "HTTP_AUTHORIZATION" => token,
        "Content-Type" => "application/json",
        "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
      }
      get "/bucketlists", {}, headers
    end
    it "returns a status code of 401" do
      expect(response).to have_http_status 401
    end
    it "returns the appropriate error message" do
      expect(json["errors"]).to include "invalid or missing token"
    end
  end
end
