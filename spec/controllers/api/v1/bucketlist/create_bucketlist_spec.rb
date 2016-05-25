require "rails_helper"

RSpec.describe "Creating Bucketlist", type: :request do
  before(:all) do
    @user = create(:user, active_status: true)
    token = token_generator(@user)
    @headers = {
      "AUTHORIZATION" => token,
      "Content-Type" => "application/json",
      "ACCEPT" => "application/vnd.Bucketlist.v1"
    }
  end

  context "when creating a bucketlist with invalid data" do
    before(:all) do
      post(
        "/bucketlists",
        { name: nil }.to_json,
        @headers
      )
    end

    it "should include name 'is blank' error" do
      expect(json["errors"]["name"]).to be_truthy
    end

    it "return a 422 status" do
      expect(response).to have_http_status 422
    end
  end

  context "when creating a bucketlist with valid data" do
    before(:all) do
      @bucketlist = build(:bucket_list)
      post(
        "/bucketlists",
        { name: @bucketlist.name }.to_json,
        @headers
      )
    end

    it "should return a status of 201" do
      expect(response).to have_http_status 201
    end

    it "returns the a JSON object" do
      expect(response.content_type).to eq Mime::JSON
    end

    it "returns the newly created bucketlist" do
      expect(json["name"]).to eq @bucketlist.name
    end
  end

  context "when a user tries to create bucketlist without passing a token" do
    before(:all) do
      bucketlist = build(:bucket_list)
      post(
        "/bucketlists",
        { name: bucketlist.name }.to_json,
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
