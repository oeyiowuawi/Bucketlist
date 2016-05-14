FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "testpassword"
    password_confirmation "testpassword"
  end

  factory :invalid_user, parent: :user do
    short_password = "test"
    password_confirmation short_password
    password short_password
  end
end
