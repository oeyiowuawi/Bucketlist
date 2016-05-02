RSpec.shared_examples "require log in before actions" do
  let(:user) {build(:user)}
  it "should return errors for non-logged-in user" do
    headers = {"HTTP_AUTHORIZATION" => nil}
    post "/bucketslists",
    {name: ""},
    headers
  expect(json["errors"]).to eq "Not Authenticated"
end
end
