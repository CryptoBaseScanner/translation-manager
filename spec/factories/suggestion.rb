FactoryBot.define do
  factory :suggestion, class: TranslationManager::Suggestion do
    sequence(:suggestion) { |n| "suggestion_#{n}" }
    translator_id { 1 }
    translation
  end
end
