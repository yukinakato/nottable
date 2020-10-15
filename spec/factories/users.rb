FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "user-#{format("%02d", i)}@example.com" }
    sequence(:display_name) { |i| "user-#{format("%02d", i)}" }
    sequence(:introduce) { |i| "introduce-#{format("%02d", i)}" }
    password { "password" }

    trait :with_avatar do
      avatar { Rack::Test::UploadedFile.new(Rails.root.join("spec", "factories", "cat.png")) }
    end
  end
end
