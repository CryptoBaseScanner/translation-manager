# frozen_string_literal: true

require 'rails_helper'

module TranslationManager
  RSpec.describe Translation, type: :model do
    describe '#self.bulk_import' do
      before do
        allow(GoogleTranslate).to receive(:translate).and_return('translation by google')

        described_class.bulk_import({ 'translation.key' => 'hello world', 'translation.key2' => 'hello world2' }, 1, 'test_namespace', 1)
      end

      it 'creates translations' do
        expect(Translation.find_by(namespace: 'test_namespace', language: 'en', translation_key: 'translation.key').value)
          .to eq('hello world')
      end

      it 'makes translations using google translate' do
        TranslationManager.config.languages.each do |language|
          translation = Translation.find_by(namespace: 'test_namespace', language: language, translation_key: 'translation.key')
          expect(translation.value).to eq('translation by google')
        end
      end

      it 'marks translations for other languages as stale if keys didn\'t exist in previous version' do
        TranslationManager.config.languages.each do |language|
          translation = Translation.find_by(namespace: 'test_namespace', language: language, translation_key: 'translation.key')
          expect(translation.stale).to be_truthy
        end
      end

      context 'when gets existing key and version' do
        before { described_class.bulk_import({ 'translation.key' => 'test' }, 1, 'test_namespace', 1) }

        it 'updates existing translation' do
          expect(Translation.where(namespace: 'test_namespace', language: 'en', translation_key: 'translation.key').count)
            .to eq(1)
          expect(Translation.find_by(namespace: 'test_namespace', language: 'en', translation_key: 'translation.key').value)
            .to eq('test')
        end
      end

      context 'when import new version' do
        before do
          translation = Translation.find_by(namespace: 'test_namespace', language: 'es', translation_key: 'translation.key')
          translation.value = 'es translation'
          translation.save!

          described_class.bulk_import({ 'translation.key' => 'hello world' }, 2, 'test_namespace', 1)
        end

        let(:translation) do
          Translation.find_by(namespace: 'test_namespace',
                              language: 'es',
                              translation_key: 'translation.key',
                              version: 2)
        end

        it 'copy previous translation for other languages if exist' do
          expect(translation.value).to eq('es translation')
        end

        it 'do not marks translation as stale' do
          expect(translation.stale).to be_falsey
        end
      end

      context 'N+1', :n_plus_one do
        specify do
          expect do
            described_class.bulk_import(Hash[current_scale.times.zip current_scale.times].merge({ 'version' => 1 }), 1, 'test_namespace', 1)
          end.to perform_constant_number_of_queries
        end
      end

    end
  end
end
