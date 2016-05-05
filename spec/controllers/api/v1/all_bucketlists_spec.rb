require "rails_helper"

RSpec.describe "list all the bucketlists", type: :request do
  before(:all) do
    @user = create(:user)
    create_list(:bucket_list, 3, created_by: @user.id)
  end

  context "with valid request" do
  before(:each) do
  @token = token_generator(@user)
  headers = {
    "HTTP_AUTHORIZATION" => @token,
    "Content-Type" => "application/json",
    "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
  }
  get "/bucketlists", {}, headers
  end

  it "should return a 200 status code" do
    expect(response).to have_http_status 200
  end

  it "return bucketlist belonging to current user" do
    contain_user_id = json.first.select{|k, v| v == "created_by"}.all? {|id| id == @user.id}
    expect(contain_user_id).to eq true
  end
  it "should return a count of 3" do
    expect(json.count).to eq 3
  end
  end

  context "invalid request" do
    it_behaves_like "require log in before actions"
  end

end
