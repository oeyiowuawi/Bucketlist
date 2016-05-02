RSpec.shared_examples "require log in before actions" do
  let(:user) {create(:user)}
  it "should return errors for non-logged-in user" do
    headers = {"HTTP_AUTHORIZATION" => nil}
    post "/bucketlists",
    {name: ""},
    headers
  expect(json["errors"]).to eq "Not Authenticated"
end
end
