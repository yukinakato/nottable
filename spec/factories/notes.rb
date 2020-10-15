FactoryBot.define do
  factory :note do
    sequence(:title) { |i| "note-title-#{format("%02d", i)}" }
    user
    markdown

    trait :markdown do
      association :note_entity, factory: :markdown_note
    end

    trait :richnote do
      association :note_entity, factory: :rich_note
    end
  end
end
