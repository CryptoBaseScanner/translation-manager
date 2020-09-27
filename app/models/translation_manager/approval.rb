module TranslationManager
  class Approval < ApplicationRecord
    belongs_to :suggestion, foreign_key: 'translation_manager_suggestion_id'
  end
end