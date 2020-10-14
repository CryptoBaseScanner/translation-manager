# frozen_string_literal: true

require 'google/cloud/translate/v2'
require 'rails_helper'

TranslationManager.setup do |config|
  config.google_translate_credentials = {}
end

def stub_google_translate(to_translate, to_return, language = 'ru')
  translated = double
  allow(translated).to receive(:text).and_return(to_return)
  client = double
  allow(client).to receive(:translate).with(to_translate, { from: 'en', to: language })
                     .and_return(translated)
  allow(Google::Cloud::Translate).to receive(:translation_v2_service).and_return(client)
end

module TranslationManager
  describe GoogleTranslate do
    describe '#translate' do
      it 'keeps placeholders' do
        stub_google_translate('to_translate<code>not_to_translate</code>',
                              'to_translate<code>not_to_translate</code>')
        expect(GoogleTranslate.translate('to_translate{{not_to_translate}}', 'ru'))
          .to eq('to_translate{{not_to_translate}}')
      end

      it 'translates only strings' do
        stub_google_translate(1, 1)
        expect(GoogleTranslate.translate(1, 'ru'))
          .to eq(1)
      end

      it 'skips translation if target language is english' do
        stub_google_translate('test', 'translated test', 'en')
        expect(GoogleTranslate.translate('test', 'en'))
          .to eq('test')
      end
    end
  end
end