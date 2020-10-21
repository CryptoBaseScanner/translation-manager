FactoryBot.define do
  factory :translation, class: TranslationManager::Translation do
    sequence(:translation_key) { |n| "key_#{n}" }
    sequence(:value) { |n| "value_#{n}" }
    version { 1 }
    language { 'en' }
    namespace { 'test_namespace' }
    stale { false }
  end
end
