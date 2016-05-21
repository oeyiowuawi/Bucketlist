require "rails_helper"

RSpec.describe "Updating an item in a bucketlist", type: :request do
  before(:all) do
    @item = create(:item)
    @item.bucket_list.user.update_attribute("active_status", true)
    token = token_generator(@item.bucket_list.user)
    @headers = {
      "AUTHORIZATION" => token,
      "Content-Type" => "application/json",
      "ACCEPT" => "application/vnd.Bucketlist.v1"
    }
  end

  context "when updating an item with valid data" do
    before(:all) do
      @name = Faker::Name.name
      put(
        "/bucketlists/#{@item.bucket_list.id}/items/#{@item.id}",
        attributes_for(:item, name: @name, done: true).to_json,
        @headers
      )
    end

    it "should return a status code of 200" do
      expect(response).to have_http_status 200
    end

    it "should return the updated name" do
      expect(json["name"]).to eq @name
    end

    it "should return the updated done" do
      expect(json["done"]).to eq true
    end
  end

  context "when updating an item with invalid data" do
    before(:all) do
      put(
        "/bucketlists/#{@item.bucket_list.id}/items/#{@item.id}",
        attributes_for(:item, name: nil, done: true).to_json,
        @headers
      )
    end

    it "should return a status code of 422" do
      expect(response).to have_http_status 422
    end

    it "should return error message to the user" do
      expect(json["errors"]["name"]).to eq ["can't be blank"]
    end
  end

  context "when updating an item in a  bucketlist that doesn't belong to "\
    "the current user" do
    before(:each) do
      put(
        "/bucketlists/2/items/#{@item.id}",
        attributes_for(:item, name: @item.name, done: true).to_json,
        @headers
      )
    end

    it "should return a 404 status code" do
      expect(response).to have_http_status 404
    end
  end

  context "when a user tries to update item without passing a token" do
    before(:all) do
      put(
        "/bucketlists/#{@item.bucket_list.id}/items/#{@item.id}",
        { name: @item.name }.to_json,
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
