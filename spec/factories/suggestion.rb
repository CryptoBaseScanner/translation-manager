FactoryBot.define do
  factory :suggestion, class: TranslationManager::Suggestion do
    sequence(:suggestion) { |n| "suggestion_#{n}" }
    sequence(:translator_id) { |n| n }
    translation
  end
end
