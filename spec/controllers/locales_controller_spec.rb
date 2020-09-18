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
      let(:translation) { create(:translation) }
      before { get "/locales/#{translation.language}/#{translation.namespace}" }

      it 'returns translations' do
        expect(JSON.parse(response.body)[translation.key]).to eq(translation.value)
      end
    end
  end
end