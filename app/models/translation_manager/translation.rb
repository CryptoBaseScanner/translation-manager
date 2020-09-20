# frozen_string_literal: true

module TranslationManager
  class Translation < ApplicationRecord
    validates :key, uniqueness: { scope: %i[version namespace language] }

    def self.import(key, value, version, namespace)
      (TranslationManager.config.languages + [:en]).each do |language|
        translation = find_or_create_by!(
          language: language,
          namespace: namespace,
          version: version,
          key: key,
          stale: language != :en
        )
        translation.value = value
        translation.save!
      end
    end
  end
end
