require "rails_helper"

RSpec.describe "Showing Bucketlist", type: :request do
  before(:all) do
    @user1 = create(:user)
    @user2 = create(:user)
    @bucketlist1 = create(:bucket_list, created_by: @user1.id)
    @bucketlist2 = create(:bucket_list, created_by: @user2.id)
  end
  describe "when logged in," do
    context "Bucketlists that belongs to the correct user" do
      before(:all) do
        token = token_generator(@user1)
        headers = {
          "HTTP_AUTHORIZATION" => token,
          "Content-Type" => "application/json",
          "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
        }
        get "/bucketlists/#{@bucketlist1.id}", {}, headers
      end

      it "should return a status code of 200" do
        expect(response).to have_http_status 200
      end

      it "should return only bucketlist that belongs to the current user" do
        expect(json["name"]).to eq @bucketlist1.name
      end
    end

    context "Bucketlist that doesn't belong to a user" do
      before(:all) do
        token = token_generator(@user1)
        headers = {
          "HTTP_AUTHORIZATION" => token,
          "Content-Type" => "application/json",
          "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
        }
        get "/bucketlists/#{@bucketlist2.id}", {}, headers
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
    it_behaves_like "require log in before actions"
  end
end
