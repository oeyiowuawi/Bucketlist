RSpec.shared_examples "require log in before actions" do
  before(:each) do
    headers = {
      "HTTP_AUTHORIZATION" => nil,
      "Content-Type" => "application/json",
      "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
    }

    post "/bucketlists", { name: nil }.to_json, headers
  end
  it "should return errors for non-logged-in user" do
    expect(json["errors"]).to eq "Not Authenticated"
  end
  it "should return a unauthorized status code" do
    expect(response).to have_http_status 401
  end
end
