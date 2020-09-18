# frozen_string_literal: true

module TranslationManager
  class Import < ApplicationRecord
    has_one_attached :file
    enum status: { processing: 'processing', finished: 'finished' }

    def import!
      data = flatten_hash(YAML.safe_load(file.download, [Symbol]))
      data.each do |key, value|
        Translation.create(
          language: 'en',
          namespace: namespace,
          version: data['version'],
          key: key,
          value: value
        )
      end
      finished!
    end

    private

    def flatten_hash(hash)
      hash.each_with_object({}) do |(k, v), h|
        if v.is_a? Hash
          flatten_hash(v).map do |h_k, h_v|
            h["#{k}.#{h_k}"] = h_v
          end
        else
          h[k] = v
        end
      end
    end
  end
end
