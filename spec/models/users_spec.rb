require "rails_helper"
RSpec.describe "User", type: :model do
  subject { build(:user) }

  describe "atrribute validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(2) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_length_of(:password).is_at_least(7) }
    it { is_expected.to have_secure_password }
    it { is_expected.to have_many(:bucket_lists).with_foreign_key(:created_by) }
  end

  describe "create User" do
    context "with valid User attributes" do
      it { is_expected.to be_valid }
    end

    context "with invalid User" do
      it "email " do
        subject.email = "@lekan"
        expect(subject).to be_invalid
      end
      it "name" do
        subject.name = "t"
        expect(subject).to be_invalid
      end
    end
  end

  describe ".find_by_credentials" do
    let(:auth_params) { { email: subject.email, password: subject.password } }
    it "returns user if correct credentials are supplied" do
      subject.save
      expect(User.find_by_credentials(auth_params).name).to eq subject.name
    end
    it "returns nil if invalid credentials are supplied" do
      subject.email = Faker::Internet.email
      expect(User.find_by_credentials(auth_params)).to eq nil
    end
  end
end
