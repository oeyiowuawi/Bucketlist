require "rails_helper"

RSpec.describe "Creating item ", type: :request do
  before(:all) do
    @item = build(:item)
    user = @item.bucket_list.user
    user.update_attribute("active_status", true)
    token = token_generator(user)
    @headers = {
      "AUTHORIZATION" => token,
      "Content-Type" => "application/json",
      "ACCEPT" => "application/vnd.Bucketlist.v1"
    }
  end

  context "when creating an item with valid data" do
    before(:all) do
      post(
        "/bucketlists/#{@item.bucket_list.id}/items",
        { name: @item.name, done: @item.done }.to_json,
        @headers
      )
    end

    it "should return a status code of 201" do
      expect(response).to have_http_status 201
    end

    it "should return the name of the newly created item" do
      expect(json["name"]).to eq @item.name
    end

    it "should return the attribute done of the newly created item" do
      expect(json["done"]).to eq false
    end
  end

  context "when creating an item with invalid name attribute" do
    before(:all) do
      post(
        "/bucketlists/#{@item.bucket_list.id}/items",
        { name: nil, done: @item.done }.to_json,
        @headers
      )
    end

    it "should return  status a 422" do
      expect(response).to have_http_status 422
    end

    it "should return can't be blank error" do
      expect(json["errors"]["name"]).to be_truthy
    end
  end

  context "when a user tries to create item without passing a token" do
    before(:all) do
      post(
        "/bucketlists/#{@item.bucket_list.id}/items",
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
