FactoryGirl.define do
  factory :item do
    name {Faker::Name.name}
    done false
    bucketlist
  end
end
