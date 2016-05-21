require "rails_helper"
RSpec.describe "Invalid Endpoint", type: :request do
  before(:all) do
    @user = create(:user, active_status: true)
    token = token_generator(@user)
    @headers = {
      "AUTHORIZATION" => token,
      "Content-Type" => "application/json",
      "ACCEPT" => "application/vnd.Bucketlist.v1"
    }
  end

  context "when using a get request to an invalid endpoint " do
    before(:all) do
      get "/bucketlist", {}, @header
    end

    it "should return a status code of 404" do
      expect(response).to have_http_status 404
    end

    it "should a message to the consumer to read the API doc" do
      expect(json["error"]).to include "Read The Api doc"
    end
  end

  context "when using a post request to an invalid endpoint" do
    before(:all) do
      post "/bucketlist", { name: Faker::Lorem.words(4) }, @header
    end

    it "should return a status code of 404" do
      expect(response).to have_http_status 404
    end

    it "should a message to the consumer to read the API doc" do
      expect(json["error"]).to include "Invalid Endpoint"
    end
  end

  context "when using a put request to an invalid endpoint" do
    before(:all) do
      put "/bucketlist/1", { name: Faker::Lorem.words(4) }, @header
    end

    it "should return a status code of 404" do
      expect(response).to have_http_status 404
    end

    it "should a message to the consumer to read the API doc" do
      expect(json["error"]).to include "Read The Api doc and try again"
    end
  end

  context "when using a delete request to an invalid endpoint" do
    before(:all) do
      delete "/bucketlist/1", { name: Faker::Lorem.words(4) }, @header
    end

    it "should return a status code of 404" do
      expect(response).to have_http_status 404
    end

    it "should a message to the consumer to read the API doc" do
      expect(json["error"]).to include "Read The Api doc and try again"
    end
  end
end
