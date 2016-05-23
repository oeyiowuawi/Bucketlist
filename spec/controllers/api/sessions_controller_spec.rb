require "rails_helper"

RSpec.describe Api::SessionsController, type: :request do
  before(:all) do
    @user = create(:user)
  end
  describe "Log in" do
    context "when trying to log in with with valid credential" do
      before(:all) do
        header = {
          "Content-Type" => "application/json",
          "ACCEPT" => "application/vnd.Bucketlist.v1"
        }
        post(
          "/auth/login", {
            email: @user.email,
            password: @user.password }.to_json, header
        )
      end

      it "returns a status code of 200" do
        expect(response).to have_http_status 200
      end

      it "returns a token" do
        expect(json["auth_token"]).to be_truthy
      end
    end

    context "when trying to log in with invalid credential" do
      before(:all) do
        invalid_password = "1234567"

        header = {
          "Content-Type" => "application/json",
          "ACCEPT" => "application/vnd.Bucketlist.v1"
        }
        post(
          "/auth/login", {
            email: @user.email,
            password: invalid_password }.to_json, header
        )
      end

      it "returns a 401 status code" do
        expect(response).to have_http_status :unauthorized
      end

      it "returns ivalid username or password error" do
        expect(json["error"]).to eq messages.bad_authentication
      end
    end
  end

  describe "log out" do
    context "when logged in users try to log out" do
      before(:all) do
        user = @user
        user.update_attribute("active_status", true)
        headers = {
          "AUTHORIZATION" => token_generator(user),
          "Content-Type" => "application/json",
          "ACCEPT" => "application/vnd.bucketlist.v1"
        }
        get "/auth/logout", {}, headers
      end

      it "returns a status code of 200" do
        expect(response).to have_http_status 200
      end

      it "returns the log out message" do
        expect(json["message"]).to eq messages.logout
      end
    end

    context "when non-logged in users without a token try to log out" do
      it "shows appropriate error message" do
        headers = {
          "Content-Type" => "application/json",
          "ACCEPT" => "application/vnd.Bucketlist.v1"
        }

        get "/auth/logout", {}, headers
        expect(json["errors"]).to include messages.not_authenticated
      end
    end

    context "when Non-logged in user with valid token try to log out" do
      before(:all) do
        token = token_generator(@user)
        headers = {
          "AUTHORIZATION" => token,
          "Content-Type" => "application/json",
          "ACCEPT" => "application/vnd.Bucketlist.v1"
        }
        get "/auth/logout", {}, headers

        get(
          "/bucketlists",
          {},
          "AUTHORIZATION" => token,
          "Content-Type" => "application/json",
          "ACCEPT" => "application/vnd.Bucketlist.v1"
        )
      end

      it " returns a status code of 401" do
        expect(response).to have_http_status 401
      end

      it " returns an error message " do
        expect(json["error"]).to include messages.must_be_logged_in
      end
    end

    context "when a logged-in user with Expired Token tries to log out " do
      before(:all) do
        user = create(:user, active_status: true)
        token = AuthToken.encode({ user_id: user.id }, 3.seconds.from_now)
        sleep 5
        headers = {
          "AUTHORIZATION" => token,
          "Content-Type" => "application/json",
          "ACCEPT" => "application/vnd.Bucketlist.v1"
        }
        get "/auth/logout", {}, headers
      end

      it "returns a status code of 401" do
        expect(response).to have_http_status 401
      end

      it "returns expired token error" do
        expect(json["errors"]).to eq messages.expired_token
      end
    end

    context "when a logged-in user with Invalid Token tries to log out" do
      before(:all) do
        user = create(:user, active_status: true)
        token = token_generator(user) << "invalid"
        headers = {
          "AUTHORIZATION" => token,
          "Content-Type" => "application/json",
          "ACCEPT" => "application/vnd.Bucketlist.v1"
        }
        get "/bucketlists", {}, headers
      end

      it "returns a status code of 401" do
        expect(response).to have_http_status 401
      end

      it "returns Not Authenticated error " do
        expect(json["errors"]).to include messages.not_authenticated
      end
    end
  end
end
