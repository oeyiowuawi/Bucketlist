require "rails_helper"

RSpec.describe "Showing Bucketlist", type: :request do
  before(:all) do
    @user1 = create(:user, active_status: true)
    @user2 = create(:user)
    @bucketlist1 = create(:bucket_list, created_by: @user1.id)
    @bucketlist2 = create(:bucket_list, created_by: @user2.id)
    token = token_generator(@user1)
    @headers = {
      "AUTHORIZATION" => token,
      "Content-Type" => "application/json",
      "ACCEPT" => "application/vnd.Bucketlist.v1"
    }
  end

  context "when trying to view bucketlist that belongs to the current user" do
    before(:all) do
      get "/bucketlists/#{@bucketlist1.id}", {}, @headers
    end

    it "should return a status code of 200" do
      expect(response).to have_http_status 200
    end

    it "should return only bucketlist that belongs to the current user" do
      expect(json["name"]).to eq @bucketlist1.name
    end
  end

  context "when trying to view bucketlist that doesn't belong to the user" do
    before(:all) do
      get "/bucketlists/#{@bucketlist2.id}", {}, @headers
    end

    it "returns a status code of 404" do
      expect(response).to have_http_status 404
    end

    it "returns an error message telling the user what the issue is" do
      expect(json["errors"]).to include messages.resource_not_found
    end
  end

  context "when trying to view a bucketlist without passing in a token" do
    before(:all) do
      headers = {
        "Content-Type" => "application/json",
        "ACCEPT" => "application/vnd.Bucketlist.v1"
      }

      get "/bucketlists/#{@bucketlist1.id}", {}, headers
    end

    it "should return errors for non-logged-in user" do
      expect(json["errors"]).to include messages.not_authenticated
    end

    it "should return a unauthorized status code" do
      expect(response).to have_http_status 401
    end
  end
end
