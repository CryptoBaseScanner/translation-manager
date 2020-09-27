module TranslationManager
  class Suggestion < ApplicationRecord
    belongs_to :translation, foreign_key: 'translation_manager_translation_id'
    has_many :approvals, foreign_key: 'translation_manager_suggestion_id'
    scope :approved, -> { joins(:approvals) }

    def approved_by
      approvals.pluck(:approved_by)
    end
  end
end
