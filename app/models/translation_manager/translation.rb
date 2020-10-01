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

    def self.import(key, value, version, namespace, user_id)
      (TranslationManager.config.languages + [:en]).each do |language|
        translation_params = { namespace: namespace, language: language, key: key, translator_id: user_id }
        translation = find_or_create_by!(
          translation_params.merge({ stale: language != :en, version: version })
        )

        if language != :en
          translation.stale = translation.previous_value ? false : true
          translation.value = translation.previous_value || GoogleTranslate.translate(value, language)
        else
          translation.value = value
        end
        translation.save!
      end
    end

    def previous_value
      @previous_value ||= self.class.find_by(
        namespace: namespace,
        language: language,
        key: key,
        version: version - 1
      )&.value
    end
  end
end
