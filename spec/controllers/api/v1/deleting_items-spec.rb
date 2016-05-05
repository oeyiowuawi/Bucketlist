require "rails_helper"

RSpec.describe "when deleting an item ",type: :request do
  before(:all) do
    bucketlist = create(:bucket_list)
    @item1, @item2 = create_list(:item, 2, bucket_list: bucketlist)
  end
  context "in a bucketlist with valid parameters" do
    before(:each) do
      @user = @item1.bucket_list.user
      token = token_generator(@user)
      headers = {
        "HTTP_AUTHORIZATION" => token,
        "Content-Type" => "application/json",
        "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
      }
      delete "/bucketlists/#{@item1.bucket_list.id}/items/#{@item1.id}", { }.to_json, headers
    end

    it "should return a 204 status" do
      expect(response).to have_http_status 204
    end

    it "should return the appropriate number of items" do
      binding.pry
      bucketlist = @user.bucket_lists.find(@item1.bucket_list.id)
      expect(bucketlist.items.count).to eq 1
    end

  end

    context "in a bucketlist with invalid item id " do
      before(:each) do
        @user = @item1.bucket_list.user
        token = token_generator(@user)
        headers = {
          "HTTP_AUTHORIZATION" => token,
          "Content-Type" => "application/json",
          "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
        }
        delete "/bucketlists/#{@item1.bucket_list.id}/items/3", { }.to_json, headers
      end

      it "should return a status code of 404" do
        expect(response).to have_http_status 404
      end

      it "should return error message" do
        expect(json["errors"]).to include "Cannot locate the resource"
      end

    end

    context "in a bucketlist that do not belong to user " do
      before(:each) do
        @user = @item2.bucket_list.user
        token = token_generator(@user)
        headers = {
          "HTTP_AUTHORIZATION" => token,
          "Content-Type" => "application/json",
          "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
        }
        delete "/bucketlists/2/items/#{@item2.id}", { }.to_json, headers
      end

      it "should return a status code of 404" do
        expect(response).to have_http_status 404
      end

      it "should return error message" do
        expect(json["errors"]).to include "Cannot locate the resource"
      end

    end
end
