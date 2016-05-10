require "rails_helper"

RSpec.describe "when trying to delete a bucketlist", type: :request do
  before(:all) do
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

  describe "as a logged In user" do
    describe "that owns the  bucketlist" do
      it "returns a status code of 204" do
        delete "/bucketlists/#{@bucketlist1.id}", {}, @headers
        expect(response).to have_http_status 204
      end
    end
    describe "that doesn't own the bucketlist " do
      it "returns a status code of 404" do
        delete "/bucketlists/#{@bucketlist2.id}", {}, @headers
        expect(response).to have_http_status 404
      end
    end
  end
end
