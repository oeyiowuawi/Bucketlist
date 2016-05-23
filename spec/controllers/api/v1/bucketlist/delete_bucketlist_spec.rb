require "rails_helper"

RSpec.describe "Deleting Bucketlist", type: :request do
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

  context "when trying to delete bucketlist that belongs to the user" do
    before(:all) do
      delete "/bucketlists/#{@bucketlist1.id}", {}, @headers
    end

    it "returns a status code of 200" do
      expect(response).to have_http_status 200
    end

    it "should return success message" do
      expect(json["message"]).to include messages.deleted
    end
  end

  context "when trying to delete bucketlist that do not belong to the user" do
    it "returns a status code of 404" do
      delete "/bucketlists/#{@bucketlist2.id}", {}, @headers
      expect(response).to have_http_status 404
    end
  end

  context "when deleting bucketlist that has 3 items" do
    it "should reduce item count by 3" do
      bucketlist = create(:bucket_list, created_by: @user1.id)
      create_list(:item, 3, bucket_list: bucketlist)
      expect do
        delete "/bucketlists/#{bucketlist.id}", {}, @headers
      end.to change(Item, :count).by(-3)
    end
  end

  context "when a user tries to delete bucketlist without passing a token" do
    before(:all) do
      delete(
        "/bucketlists/#{@bucketlist1.id}",
        {},
        "Content-Type" => "application/json",
        "ACCEPT" => "application/vnd.Bucketlist.v1"
      )
    end

    it "returns a status code of 401" do
      expect(response).to have_http_status 401
    end

    it "returns a NotAuthenticatedError " do
      expect(json["errors"]).to include messages.not_authenticated
    end
  end
end
