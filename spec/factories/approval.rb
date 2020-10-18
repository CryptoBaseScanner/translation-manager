FactoryBot.define do
  factory :approval, class: TranslationManager::Approval do
    suggestion
    sequence(:approved_by) { |n| n }
  end
end
