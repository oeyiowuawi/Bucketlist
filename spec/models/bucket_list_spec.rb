require "rails_helper"

RSpec.describe BucketList, type: :model do
  subject { build(:bucket_list) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to have_many(:items) }
    it { is_expected.to have_many(:items) }
    it { is_expected.to belong_to(:user).with_foreign_key(:created_by) }
    it { is_expected.to validate_presence_of(:created_by) }
  end

  describe ".search" do
    before(:all) do
      user = create(:user)
      create(:bucket_list, name: "What happens in gidi", created_by: user.id)
      create(:bucket_list, name: "stays in gidi", created_by: user.id)
      create(:bucket_list, name: "Hahaha", created_by: user.id)
      @user_bucketlists = User.find(user.id).bucket_lists
    end

    context "when searching through the with a querry that has result" do
      it "returns the correct number of records found" do
        expect(@user_bucketlists.search("in gidi").count).to eq 2
      end
    end

    context "when searching with a querry that doessn't have a result" do
      it "returns an empty record" do
        expect(@user_bucketlists.search("in the zhenghen").empty?).to eq true
      end
    end
  end
end
