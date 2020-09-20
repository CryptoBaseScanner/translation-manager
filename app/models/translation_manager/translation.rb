# frozen_string_literal: true

module TranslationManager
  class Translation < ApplicationRecord
    validates :key, uniqueness: { scope: %i[version namespace] }

    def self.import(key, value, version, namespace)
      translation = find_or_create_by!(
        language: 'en',
        namespace: namespace,
        version: version,
        key: key
      )
      translation.value = value
      translation.save!
    end
  end
end
