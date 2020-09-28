# frozen_string_literal: true

module TranslationManager
  class Translation < ApplicationRecord
    validates :key, uniqueness: { scope: %i[version namespace language] }
    has_many :suggestions, foreign_key: 'translation_manager_translation_id'

    def approved_translation
      return value unless suggestions.approved.any?

      suggestions.joins(:approvals)
                 .select('translation_manager_suggestions.suggestion, count(1) as count_all')
                 .group('translation_manager_suggestions.suggestion')
                 .order('count_all DESC').first.suggestion
    end

    def self.import(key, value, version, namespace)
      (TranslationManager.config.languages + [:en]).each do |language|
        translation_params = {
          namespace: namespace,
          language: language,
          key: key
        }
        translation = find_or_create_by!(
          translation_params.merge({ stale: language != :en, version: version })
        )
        if language != :en
          previous_translation = find_by(
            translation_params.merge({ version: version - 1 })
          )
          if previous_translation
            translation.value = previous_translation.value
            translation.stale = false
          else
            translation.value = value
          end
        else
          translation.value = value
        end
        translation.save!
      end
    end
  end
end
