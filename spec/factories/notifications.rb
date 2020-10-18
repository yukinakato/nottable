FactoryBot.define do
  factory :notification do
    user
    for_note

    trait :for_note do
      association :notify_entity, :markdown, factory: :note
    end

    trait :for_follow do
      association :notify_entity, factory: :relationship
    end

    trait :for_bookmark do
      association :notify_entity, factory: :bookmark
    end
  end
end
