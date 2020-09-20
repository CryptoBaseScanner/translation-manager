# frozen_string_literal: true

require 'rails_helper'

TranslationManager.setup do |config|
  config.languages = %i[es th kr]
end

module TranslationManager
  RSpec.describe Translation, type: :model do
    describe '#self.import' do
      before { described_class.import('en.translation.key', 'hello world', 1, 'test_namespace') }

      it 'creates translations' do
        expect(Translation.find_by(namespace: 'test_namespace', language: 'en', key: 'en.translation.key').value)
          .to eq('hello world')
      end

      it 'creates translations for other languages' do
        TranslationManager.config.languages.each do |language|
          translation = Translation.find_by(namespace: 'test_namespace', language: language, key: 'en.translation.key')
          expect(translation.stale).to be_truthy
        end
      end

      context 'when gets existing key and version' do
        before { described_class.import('en.translation.key', 'test', 1, 'test_namespace') }

        it 'updates existing translation' do
          expect(Translation.where(namespace: 'test_namespace', language: 'en', key: 'en.translation.key').count)
            .to eq(1)
          expect(Translation.find_by(namespace: 'test_namespace', language: 'en', key: 'en.translation.key').value)
            .to eq('test')
        end
      end
    end
  end
end
