require "rails_helper"

RSpec.describe "getting a particular bucketlist",type: :request do
  before(:all) do
    @user1 = create(:user)
    @user2 = create(:user)
    @bucketlist1 = create(:bucket_list, created_by: @user1.id)
    @bucketlist2, @bucketlist3 = create_list(:bucket_list, 2, created_by: @user2.id)
  end
  context ",when logged in," do
    describe "that belongs to the correct user" do
      before(:each) do
        token = token_generator(@user1)
        headers = {"HTTP_AUTHORIZATION" => token}
        get "/bucketlists/#{@bucketlist1.id}", {}, headers
      end

      it "should return a status code of 200" do
        expect(response).to have_http_status 200
      end

      it "should return only bucketlist that belogs to the User making the request" do
        expect(json["name"]).to eq @bucketlist1.name
      end

    end

    describe "that doesn't belong to a user" do
      before(:each) do
        token = token_generator(@user1)
        headers = {"HTTP_AUTHORIZATION" => token}
        get "/bucketlists/#{@bucketlist2.id}", {}, headers
      end

      it "returns a status code of 404" do
        expect(response).to have_http_status 404
      end

      it "returns an error message telling the user what the issue is" do
        expect(json["message"]).to include "bucketlist not found"
      end
    end
  end

  context "when not logged in" do
    it_behaves_like "require log in before actions"
  end

end
