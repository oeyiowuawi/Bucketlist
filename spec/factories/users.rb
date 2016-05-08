FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "testpassword"
    password_confirmation "testpassword"
  end

  factory :invalid_user, parent: :user do
    password_confirmation "test"
    password "test"
  end
end
