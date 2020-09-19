# frozen_string_literal: true

require 'rails_helper'

module TranslationManager
  RSpec.describe LocalesController, type: :request do
    include Engine.routes.url_helpers

    context 'when imports YAML' do
      before do
        post '/locales/en/test_namespace/import',
             params: File.open("#{__dir__}/../files/translations.yml").read,
             headers: { 'CONTENT_TYPE': 'application/yaml' }
      end

      let(:translation_import_id) { JSON.parse(response.body)['translation_import_id'] }

      it 'saves data to translation import' do
        expect(Import.where(id: translation_import_id)).to exist
      end

      it 'queues an import job' do
        assert_enqueued_with(
          job: ImportJob,
          args: [translation_import_id]
        )
      end
    end

    context 'when request translation' do
      let!(:translation_v1) { create(:translation, version: 1) }
      let!(:translation_v2) { create(:translation, version: 2) }

      it 'returns translations according to version' do
        get "/locales/v1/#{translation_v1.language}/#{translation_v1.namespace}"
        expect(JSON.parse(response.body)[translation_v1.key]).to eq(translation_v1.value)
        get "/locales/v2/#{translation_v2.language}/#{translation_v2.namespace}"
        expect(JSON.parse(response.body)[translation_v2.key]).to eq(translation_v2.value)
        expect(JSON.parse(response.body)).not_to match(hash_including(translation_v1.key))
      end
    end
  end
end