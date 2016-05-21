require "rails_helper"

RSpec.describe "Deleting an item ", type: :request do
  before(:all) do
    bucketlist = create(:bucket_list)
    @item1, @item2 = create_list(:item, 2, bucket_list: bucketlist)
    @user = @item1.bucket_list.user
    @user.update_attribute("active_status", true)
    token = token_generator(@user)
    @headers = {
      "AUTHORIZATION" => token,
      "Content-Type" => "application/json",
      "ACCEPT" => "application/vnd.Bucketlist.v1"
    }
  end

  context "when deleting an item in a bucketlist that belongs to the current "\
    "user" do
    before(:all) do
      delete(
        "/bucketlists/#{@item1.bucket_list.id}/items/#{@item1.id}",
        {},
        @headers
      )
    end

    it "should return a 200 status" do
      expect(response).to have_http_status 200
    end

    it "should return a message to the user" do
      expect(json["message"]).to include messages.deleted
    end

    it "should return the appropriate number of items" do
      bucketlist = @user.bucket_lists.find(@item1.bucket_list.id)
      expect(bucketlist.items.count).to eq 1
    end
  end

  context "when deleting an item that doesn't belong to the current user" do
    before(:all) do
      delete "/bucketlists/#{@item1.bucket_list.id}/items/3", {}, @headers
    end

    it "should return a status code of 404" do
      expect(response).to have_http_status 404
    end

    it "should return error message" do
      expect(json["errors"]).to include messages.resource_not_found
    end
  end

  context "when deleting an item in a bucketlist that do not belong to current"\
    " user" do
    before(:all) do
      delete "/bucketlists/2/items/#{@item2.id}", {}.to_json, @headers
    end

    it "should return a status code of 404" do
      expect(response).to have_http_status 404
    end

    it "should return error message" do
      expect(json["errors"]).to include messages.resource_not_found
    end
  end

  context "when a user tries to delete item without passing a token" do
    before(:all) do
      delete(
        "/bucketlists/2/items/#{@item2.id}",
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
