FactoryBot.define do
  factory :markdown_note do
    sequence(:content) { |i| "markdown-content-#{format("%02d", i)}" }
  end
end
