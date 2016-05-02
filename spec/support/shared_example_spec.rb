RSpec.shared_examples "require log in before actions" do
  let(:user) {build(:user)}
  it "should return errors for non-logged-in user" do
  post ("/bucketslists", {
    name: "examples"
  },"Authorization" => token_generator(user)+ "invalid"
  )
  expect(json["errors"]).to eq "Not Authenticated"
end
end
