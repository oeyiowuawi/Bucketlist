FactoryGirl.define do
  factory :bucketlist do
    name "MyString"
  end

  factory :invalid_bucketlist do
    name ""
  end
end
