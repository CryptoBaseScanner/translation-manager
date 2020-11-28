# frozen_string_literal: true

require 'rails_helper'

module TranslationManager
  RSpec.describe TranslationsController, type: :request do
    include Engine.routes.url_helpers

    context 'when imports YAML' do
      let(:user_id) { 1 }

      before do
        allow_any_instance_of(::ApplicationController).to receive(:current_user)
          .and_return(instance_double('User', id: user_id))

        post '/locales/v1/en/test_namespace/import',
             params: File.read("#{__dir__}/../files/translations.yml"),
             headers: { 'CONTENT_TYPE': 'application/yaml' }
      end

      let(:translation_import_id) { JSON.parse(response.body)['translation_import_id'] }

      it 'saves data to translation import' do
        expect(Import.where(id: translation_import_id)).to exist
      end

      it 'queues an import job with user_id' do
        assert_enqueued_with(
          job: ImportJob,
          args: [translation_import_id, user_id]
        )
      end
    end

    context 'when request translation' do
      let!(:translation_v1) { create(:translation, version: 1) }
      let!(:translation_v2) { create(:translation, version: 2) }

      it 'returns translations according to version' do
        get "/locales/v1/#{translation_v1.language}/#{translation_v1.namespace}"
        expect(JSON.parse(response.body)[translation_v1.translation_key]).to eq(translation_v1.value)
        get "/locales/v2/#{translation_v2.language}/#{translation_v2.namespace}"
        expect(JSON.parse(response.body)[translation_v2.translation_key]).to eq(translation_v2.value)
        expect(JSON.parse(response.body)).not_to match(hash_including(translation_v1.translation_key))
      end

      it 'returns translations with most approved suggestions' do
        translation = create(:translation, version: 1)
        suggestion = create(:suggestion, translation: translation)
        suggestion2 = create(:suggestion, translation: translation)
        suggestion.approvals.create(approved_by: 1)
        suggestion2.approvals.create(approved_by: 2)
        suggestion2.approvals.create(approved_by: 3)
        get "/locales/v1/#{translation_v1.language}/#{translation_v1.namespace}"
        expect(JSON.parse(response.body)[translation.translation_key]).to eq(suggestion2.suggestion)
      end

      it 'returns first suggestion when suggestion didn\'t approved yet' do
        translation = create(:translation, version: 1)
        suggestion = create(:suggestion, translation: translation)
        create(:suggestion, translation: translation)
        get "/locales/v1/#{translation_v1.language}/#{translation_v1.namespace}"
        expect(JSON.parse(response.body)[translation.translation_key]).to eq(suggestion.suggestion)
      end

      context 'translations N+1', :n_plus_one do
        populate { |n| create_list(:translation, n) }

        specify do
          expect { get '/locales/v1/en/test_namespace' }.to perform_constant_number_of_queries
        end
      end

      context 'suggestions N+1', :n_plus_one do
        populate { |n| create_list(:suggestion, n, translation: translation_v1) }

        specify do
          expect { get '/locales/v1/en/test_namespace' }.to perform_constant_number_of_queries
        end
      end
    end

    describe 'GET stale' do
      let!(:translation) { create(:translation, version: 1, stale: false) }
      let!(:translation_stale) { create(:translation, version: 1, stale: true) }
      let!(:suggestions) { create_list(:suggestion, 5, translation: translation_stale) }

      before { get '/locales/v1/en/test_namespace/stale' }

      it 'returns only stale translations' do
        expect(JSON.parse(response.body).count).to eq(1)
      end

      it 'returns suggestions for each translation' do
        expect(JSON.parse(response.body).values.first['suggestions'].count).to eq(5)
      end

      context 'translations N+1', :n_plus_one do
        populate { |n| create_list(:translation, n, stale: true) }

        specify do
          expect { get '/locales/v1/en/test_namespace/stale' }.to perform_constant_number_of_queries
        end
      end
    end
  end
end
