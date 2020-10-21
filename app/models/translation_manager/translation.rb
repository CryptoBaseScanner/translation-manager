# frozen_string_literal: true

module TranslationManager
  class Translation < ApplicationRecord
    validates :translation_key, uniqueness: { scope: %i[version namespace language] }
    has_many :suggestions, foreign_key: 'translation_manager_translation_id'

    def update_approved_suggestion!
      the_most_approved = suggestions.group(:approvals_count).order(approvals_count: :desc).first
      the_most_approved.update(approved: true)
      suggestions.where.not(id: the_most_approved).update_all(approved: false)
    end

    def self.bulk_import(key_values, version, namespace, user_id)
      previous_values = fetch_previous_values(namespace, version)
      en_translations = key_values.map do |key, value|
        {
          namespace: namespace,
          language: 'en',
          translation_key: key,
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
          previous_value = previous_values.fetch(language.to_s, nil)&.fetch(translation[:translation_key], nil)
          translation.merge(
            {
              value: previous_value || GoogleTranslate.translate(translation[:value], language),
              language: language,
              stale: previous_value.nil?
            }
          )
        end
      end.flatten
      if defined?(ActiveRecord::ConnectionAdapters::Mysql2Adapter) &&
        ActiveRecord::Base.connection.instance_of?(ActiveRecord::ConnectionAdapters::Mysql2Adapter)
        upsert_all(en_translations + translations_other)
      else
        upsert_all(en_translations + translations_other, unique_by: %i[translation_key version namespace language])
      end
    end

    def self.fetch_previous_values(namespace, version)
      where(namespace: namespace, version: version - 1)
        .map { |t| [t.language, [t.translation_key, t.value]] }
        .group_by(&:first)
        .map { |k, v| [k, v.map(&:last).to_h] }.to_h
    end
  end
end
