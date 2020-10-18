# frozen_string_literal: true

module TranslationManager
  class Translation < ApplicationRecord
    validates :key, uniqueness: { scope: %i[version namespace language] }
    has_many :suggestions, foreign_key: 'translation_manager_translation_id'

    def update_approved_suggestion!
      max_approvals = suggestions.pluck('MAX(approvals_count)').first
      suggestions.update_all(['approved = (approvals_count == ?)', max_approvals])
    end

    def self.bulk_import(key_values, version, namespace, user_id)
      previous_values = fetch_previous_values(namespace, version)
      en_translations = key_values.map do |key, value|
        {
          namespace: namespace,
          language: 'en',
          key: key,
          translator_id: user_id,
          value: value,
          stale: false,
          version: version,
          created_at: Time.now,
          updated_at: Time.now
        }
      end
      translations_other = TranslationManager.config.languages.map do |language|
        en_translations.map do |translation|
          previous_value = previous_values.fetch(language.to_s, nil)&.fetch(translation[:key], nil)
          translation.merge(
            {
              value: previous_value || GoogleTranslate.translate(translation[:value], language),
              language: language,
              stale: previous_value.nil?
            }
          )
        end
      end.flatten
      upsert_all(en_translations + translations_other)
    end

    def self.fetch_previous_values(namespace, version)
      where(namespace: namespace, version: version - 1)
        .map { |t| [t.language, [t.key, t.value]] }
        .group_by(&:first)
        .map { |k, v| [k, v.map(&:last).to_h] }.to_h
    end
  end
end
