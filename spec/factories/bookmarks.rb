FactoryBot.define do
  factory :bookmark do
    user
    association :note, :markdown
  end
end
