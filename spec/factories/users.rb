FactoryGirl.define do
  factory :user do
    name "Olalekan"
    email "olalekan.eyiowuawi@andela.com"
    password "testpassword"
    password_confirmation "testpassword"
  end

  factory :invalid_user, parent: :user do
    password_confirmation "test"
    password "test"
  end
end
