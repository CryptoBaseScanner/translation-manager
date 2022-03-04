# frozen_string_literal: true

module TranslationManager
  class Import < ApplicationRecord
    enum status: { processing: 'processing', finished: 'finished' }

    def import!(user_id)
      Translation.bulk_import(data, data['version'], namespace, user_id)
      finished!
    end

    def file=(file)
      if file.is_a?(String)
        content = file
      elsif file.respond_to?(:read)
        content = file.read
      else
        raise "Invalid import format"
      end

      write_attribute(:file, Base64.encode64(content))
    end

    private

    def data
      flatten_hash(YAML.safe_load(Base64.decode64(file), permitted_classes: [Symbol]))
    end

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
