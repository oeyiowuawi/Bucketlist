FactoryGirl.define do
  factory :bucket_list do
    name "MyString"
  end
  
  factory :invalid_bucketlist do
    name ""
  end
end