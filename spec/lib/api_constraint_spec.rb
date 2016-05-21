require "rails_helper"

describe ApiConstraints do
  let(:api_constraints_v1) { ApiConstraints.new(version: 1) }
  let(:api_constraints_v2) { ApiConstraints.new(version: 2, default: true) }

  describe "matches?" do
    context "when the version is supplied in the 'Accept' header" do
      it "returns true when the version matches the 'Accept' header" do
        request = double(
          host: "localhost:3000",
          headers: { "Accept" => "application/vnd.Bucketlist.v1" }
        )
        expect(api_constraints_v1.matches?(request)).to eq true
      end

      it "returns false when the version doesn't match the 'Accept' header" do
        request = double(
          host: "localhost:3000",
          headers: { "Accept" => "application/vnd.Bucketlist.v2" }
        )
        expect(api_constraints_v1.matches?(request)).to eq false
      end
    end

    context "when the version is not supplied through the header" do
      it "returns the default version when 'default' option is specified" do
        request = double(host: "localhost:3000")
        expect(api_constraints_v2.matches?(request)).to eq true
      end
    end
  end
end
