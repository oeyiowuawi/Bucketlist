FactoryGirl.define do
  factory :item do
    name { Faker::Name.name }
    done false
    bucket_list
  end
end
