require "rails_helper"

RSpec.describe BucketlistsController, type: :request do
  let (:user) do
    create(:user)
  end


  include_examples "require log in before actions"
  it_behaves_like "require log in before actions"

  context "creating a bucketlist with invalid request and params" do
    before(:each) do
      user.save
      @token = token_generator(user)
      headers = {"HTTP_AUTHORIZATION" => @token}
      post "/bucketlists",
      {name: nil},
      headers

    end

    it "should include name 'is blank' error" do
      expect(json["error"]["name"]).to eq ["can't be blank"]
    end
    it "return a 422 status" do
      expect(response).to have_http_status 422
    end

  end

  context "creating a bucketlist with valid request and params" do
    before(:each) do
      @bucketlist = build(:bucket_list)
      headers = {"HTTP_AUTHORIZATION" => token_generator(user)}
      post "/bucketlists",
      {name: @bucketlist.name},
      headers
    end

    it "should return a status of 201" do
      expect(response).to have_http_status 201
    end

    # it "returns the location of the new bucketlist" do
    #   expect(response.location).to eq bucketlist_path(@bucketlist.id)
    # end

    it "returns the a JSON object" do
      expect(response.content_type).to eq Mime::JSON
    end
  end
end
