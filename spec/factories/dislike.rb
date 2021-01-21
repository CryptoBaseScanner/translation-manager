FactoryBot.define do
  factory :dislike, class: TranslationManager::Dislike do
    suggestion
    sequence(:disliked_by) { |n| n }
  end
end
