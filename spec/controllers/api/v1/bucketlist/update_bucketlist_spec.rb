require "rails_helper"
RSpec.describe "when trying to update a bucketlist", type: :request do
  before(:all) do
    @name = Faker::Name.name
    @user1 = create(:user, active_status: true)
    @user2 = create(:user)
    @bucketlist1 = create(:bucket_list, created_by: @user1.id)
    @bucketlist2 = create(:bucket_list, created_by: @user2.id)
    token = token_generator(@user1)
    @headers = {
      "HTTP_AUTHORIZATION" => token,
      "Content-Type" => "application/json",
      "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
    }
  end

  describe "Bucketlist owner" do
    context "when updating a bucketlist with valid data" do
      before(:all) do
        put "/bucketlists/#{@bucketlist1.id}", {
          name: @name
        }.to_json, @headers
      end
      it "returns a success status code" do
        expect(response).to have_http_status 200
      end

      it "returns the updated object" do
        expect(json["name"]).to eq @name
      end
    end
    context "when updating a bucketlist with invalid data" do
      before(:all) do
        put "/bucketlists/#{@bucketlist1.id}", {
          name: nil
        }.to_json, @headers
      end
      it "returns a status code of 422" do
        expect(response).to have_http_status 422
      end
      it "return the appropriate error message to the user" do
        expect(json["errors"]["name"]).to eq ["can't be blank"]
      end
    end
  end

  context "when updating a bucketlist that doesn't belong to the user," do
    before(:all) do
      put "/bucketlists/#{@bucketlist2.id}", {
        name: @name
      }.to_json, @headers
    end

    it "returns a 404 status code" do
      expect(response).to have_http_status 404
    end

    it "returns a message to the User" do
      expect(json["errors"]).to include "Cannot locate the resource"
    end
  end
end
