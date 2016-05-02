FactoryGirl.define do
  factory :bucket_list do
    name {Faker::Name.name}
  end

  factory :invalid_bucketlist do
    name ""
  end
end
