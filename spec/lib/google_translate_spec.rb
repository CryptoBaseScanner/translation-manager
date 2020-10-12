# frozen_string_literal: true

require 'google/cloud/translate/v2'
require 'rails_helper'

TranslationManager.setup do |config|
  config.google_translate_credentials = {}
end

module TranslationManager
  describe GoogleTranslate do
    describe '#translate' do
      it 'keeps placeholders' do
        translated = double
        allow(translated).to receive(:text).and_return('to_translate<code>not_to_translate</code>')
        client = double
        allow(client).to receive(:translate).with('to_translate<code>not_to_translate</code>', { from: 'en', to: 'ru' })
                                            .and_return(translated)
        allow(Google::Cloud::Translate).to receive(:translation_v2_service).and_return(client)
        expect(GoogleTranslate.translate('to_translate{{not_to_translate}}', 'ru'))
          .to eq('to_translate{{not_to_translate}}')
      end

      it 'translates only strings' do
        translated = double
        allow(translated).to receive(:text).and_return(1)
        client = double
        allow(client).to receive(:translate).with(1, { from: 'en', to: 'ru' }).and_return(translated)
        allow(Google::Cloud::Translate).to receive(:translation_v2_service).and_return(client)
        expect(GoogleTranslate.translate(1, 'ru'))
          .to eq(1)
      end
    end
  end
end