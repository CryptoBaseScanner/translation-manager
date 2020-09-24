module TranslationManager
  class Suggestion < ApplicationRecord
    belongs_to :translation, foreign_key: 'translation_manager_translation_id'
  end
end
