require "rails_helper"

RSpec.describe BucketList, type: :model do
  subject { build(:bucket_list) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:items) }
  it { is_expected.to have_many(:items) }
  it { is_expected.to belong_to(:user).with_foreign_key(:created_by) }

  it { is_expected.to validate_presence_of(:created_by) }

  describe ".search" do
    before(:all) do
      user = create(:user)
      create(:bucket_list, name: "What happens in gidi", created_by: user.id)
      create(:bucket_list, name: "stays in gidi", created_by: user.id)
      create(:bucket_list, name: "Hahaha", created_by: user.id)
      @user_bucketlists = User.find(user.id).bucket_lists
    end
    it "returns the correct result when passed in the right queery" do
      expect(@user_bucketlists.search("in gidi").count).to eq 2
    end
    it "returns nil when given a wrong queery string" do
      expect(@user_bucketlists.search("in the zhenghen").count).to eq 0
    end
  end
end
