FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "password" }
    display_name { "myname" }
  end
end
