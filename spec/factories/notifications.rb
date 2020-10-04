FactoryBot.define do
  factory :notification do
    user { nil }
    unread { false }
  end
end
