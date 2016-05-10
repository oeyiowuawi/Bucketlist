require "rails_helper"

RSpec.describe Api::V1::BucketlistsController, type: :request do
  before(:all) do
    @user = create(:user, active_status: true)
    token = token_generator(@user)
    @headers = {
      "HTTP_AUTHORIZATION" => token,
      "Content-Type" => "application/json",
      "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
    }
  end

  it_behaves_like "require log in before actions"

  context "creating a bucketlist with invalid request and params" do
    before(:all) do
      post "/bucketlists",
           { name: nil }.to_json,
           @headers
    end

    it "should include name 'is blank' error" do
      expect(json["error"]["name"]).to eq ["can't be blank"]
    end
    it "return a 422 status" do
      expect(response).to have_http_status 422
    end
  end

  context "creating a bucketlist with valid request and params" do
    before(:all) do
      @bucketlist = build(:bucket_list)
      post "/bucketlists",
           { name: @bucketlist.name }.to_json,
           @headers
    end

    it "should return a status of 201" do
      expect(response).to have_http_status 201
    end

    it "returns the a JSON object" do
      expect(response.content_type).to eq Mime::JSON
    end
  end
end
