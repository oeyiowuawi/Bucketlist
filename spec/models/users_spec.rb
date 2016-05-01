require "rails_helper"
RSpec.describe "User", type: :model do

    subject{ build(:user)}

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_length_of(:password).is_at_least(7) }
    it { is_expected.to have_secure_password}

    describe "create User" do
    context "with valid User attributes" do
      
      it{ is_expected.to be_valid}
    end
  end
end
