require "rails_helper"

RSpec.describe "Showing Bucketlist", type: :request do
  before(:all) do
    @user1 = create(:user, active_status: true)
    @user2 = create(:user)
    @bucketlist1 = create(:bucket_list, created_by: @user1.id)
    @bucketlist2 = create(:bucket_list, created_by: @user2.id)
    token = token_generator(@user1)
    @headers = {
      "HTTP_AUTHORIZATION" => token,
      "Content-Type" => "application/json",
      "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
    }
  end
  describe "when logged in" do
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
        expect(json["errors"]).to include "Cannot locate the resource"
      end
    end
  end

  context "when not logged in" do
    before(:each) do
      headers = {
        "HTTP_AUTHORIZATION" => nil,
        "Content-Type" => "application/json",
        "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
      }

      post "/bucketlists", { name: nil }.to_json, headers
    end
    it "should return errors for non-logged-in user" do
      expect(json["errors"]).to include "Not Authenticated"
    end
    it "should return a unauthorized status code" do
      expect(response).to have_http_status 401
    end
  end
end
