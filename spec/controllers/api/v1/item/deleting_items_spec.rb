require "rails_helper"

RSpec.describe "Deleting an item ", type: :request do
  before(:all) do
    bucketlist = create(:bucket_list)
    @item1, @item2 = create_list(:item, 2, bucket_list: bucketlist)
    @user = @item1.bucket_list.user
    @user.update_attribute("active_status", true)
    token = token_generator(@user)
    @headers = {
      "HTTP_AUTHORIZATION" => token,
      "Content-Type" => "application/json",
      "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
    }
  end
  context "when deleting an item in a bucketlist that belongs to the current "\
    "user" do
    before(:each) do
      delete "/bucketlists/#{@item1.bucket_list.id}/items/#{@item1.id}", {},
             @headers
    end

    it "should return a 200 status" do
      expect(response).to have_http_status 200
    end

    it "should return a message to the user" do
      expect(json["message"]).to include "deleted"
    end

    it "should return the appropriate number of items" do
      bucketlist = @user.bucket_lists.find(@item1.bucket_list.id)
      expect(bucketlist.items.count).to eq 1
    end
  end

  context "when deleting an item that doesn't belong to the current user" do
    before(:each) do
      delete "/bucketlists/#{@item1.bucket_list.id}/items/3", {}, @headers
    end

    it "should return a status code of 404" do
      expect(response).to have_http_status 404
    end

    it "should return error message" do
      expect(json["errors"]).to include "Cannot locate the resource"
    end
  end

  context "when deleting an item in a bucketlist that do not belong to current"\
    " user" do
    before(:each) do
      delete "/bucketlists/2/items/#{@item2.id}", {}.to_json, @headers
    end

    it "should return a status code of 404" do
      expect(response).to have_http_status 404
    end

    it "should return error message" do
      expect(json["errors"]).to include "Cannot locate the resource"
    end
  end
end
