RSpec.shared_examples "require log in before actions" do
  before(:each) do
    headers = {"HTTP_AUTHORIZATION" => nil}
    post "/bucketlists",
    {name: ""},
    headers
  end
  it "should return errors for non-logged-in user" do

    expect(json["errors"]).to eq "Not Authenticated"
  end
  it "should return a unauthorized status code" do
    expect(response).to have_http_status 401
  end

end
