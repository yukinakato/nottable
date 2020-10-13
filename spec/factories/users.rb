FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "user-#{format("%02d", i)}@example.com" }
    sequence(:display_name) { |i| "user-#{format("%02d", i)}" }
    password { "password" }
  end

  trait :with_avatar do
    avatar { Rack::Test::UploadedFile.new(Rails.root.join("spec", "factories", "cat.png")) }
  end
end
