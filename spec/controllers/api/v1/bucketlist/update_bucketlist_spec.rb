require "rails_helper"
RSpec.describe "Update Bucketlist", type: :request do
  before(:all) do
    @name = Faker::Name.name
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

  context "when updating a bucketlist that belongs to current_user with "\
    "valid data" do
    before(:all) do
      put(
        "/bucketlists/#{@bucketlist1.id}",
        { name: @name }.to_json,
        @headers
      )
    end

    it "returns a success status code" do
      expect(response).to have_http_status 200
    end

    it "returns the updated object" do
      expect(json["name"]).to eq @name
    end
  end

  context "when updating a bucketlist that doesn't belong to current_user "\
    " with invalid data" do
    before(:all) do
      put(
        "/bucketlists/#{@bucketlist1.id}",
        { name: nil }.to_json,
        @headers
      )
    end

    it "returns a status code of 422" do
      expect(response).to have_http_status 422
    end

    it "return 'cant be blank' error" do
      expect(json["errors"]["name"]).to be_truthy
    end
  end

  context "when updating a bucketlist that doesn't belong to the user" do
    before(:all) do
      put(
        "/bucketlists/#{@bucketlist2.id}",
        { name: @name }.to_json,
        @headers
      )
    end

    it "returns a 404 status code" do
      expect(response).to have_http_status 404
    end

    it "returns resource not found message" do
      expect(json["errors"]).to include messages.resource_not_found
    end
  end

  context "when a user tries to update bucketlist without passing a token" do
    before(:all) do
      put(
        "/bucketlists/#{@bucketlist1.id}",
        { name: @name }.to_json,
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
