# frozen_string_literal: true

require 'google-cloud-translate'

module TranslationManager
  class GoogleTranslate
    def self.translate(value, to)
      client = Google::Cloud::Translate.translation_v2_service(
        project_id: TranslationManager.config.google_translate_credentials[:project_id],
        credentials: TranslationManager.config.google_translate_credentials
      )

      client.translate(value.gsub(/{{(.+?)}}/, '<code>\1</code>'), from: 'en', to: to)
        .text.gsub(/<code>(.+?)<\/code>/, '{{\1}}')

      # Google translate v3 client
      #
      # client = Google::Cloud::Translate.translation_service do |config|
      #   config.credentials = TranslationManager.config.google_translate_credentials
      # end
      #
      # request = Google::Cloud::Translate::V3::TranslateTextRequest.new(
      #   contents: [value],
      #   source_language_code: 'en',
      #   target_language_code: to,
      #   parent: TranslationManager.config.google_translate_credentials[:project_id],
      #   mime_type: 'text/plain'
      # )
      #
      # client.translate_text(request).text
    end
  end
end