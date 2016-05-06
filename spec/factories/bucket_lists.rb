FactoryGirl.define do
  factory :bucket_list do
    name { Faker::Name.name }
    user
  end

  factory :invalid_bucketlist do
    name ''
    user
  end
end
