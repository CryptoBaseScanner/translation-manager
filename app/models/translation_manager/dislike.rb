module TranslationManager
  class Dislike < ApplicationRecord
    belongs_to :suggestion, foreign_key: 'translation_manager_suggestion_id', counter_cache: true
    validates_uniqueness_of :disliked_by, scope: [:translation_manager_suggestion_id]

    after_save { suggestion.translation.update_suggestion_vote! }
  end
end
