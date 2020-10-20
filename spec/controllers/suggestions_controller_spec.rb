# frozen_string_literal: true

require 'rails_helper'

module TranslationManager
  RSpec.describe TranslationsController, type: :request do
    include Engine.routes.url_helpers
    before do
      allow_any_instance_of(::ApplicationController)
        .to receive(:current_user).and_return(instance_double('User', id: 1))
    end

    context 'POST #create' do
      let(:translation) { create(:translation) }
      before do
        post "/locales/v1/en/test_namespace/#{translation.key}/suggestions",
             params: { suggestion: 'my suggestion' }

        # post translation_suggestions_path(translation_id: translation.id),
        #      params: { suggestion: 'my suggestion' }
      end

      it 'creates suggestion' do
        expect(Suggestion.where(translation_manager_translation_id: translation.id)).to be_exists
      end

      it 'assigns translator to suggestion' do
        expect(Suggestion.where(translation_manager_translation_id: translation.id).first.translator_id).to eq(1)
      end

    end

    context 'GET #index' do
      let(:translation) { create(:translation) }
      let!(:suggestion) { create(:suggestion, translator_id: 1, translation: translation) }

      before do
        get "/locales/v1/en/test_namespace/#{translation.key}/suggestions"
      end

      it 'returns suggestion' do
        expect(JSON.parse(response.body, symbolize_names: true).first)
          .to match(hash_including({ translator_id: 1, suggestion: suggestion.suggestion }))
      end
    end

    context 'POST #approve' do
      let(:translation) { create(:translation) }
      let!(:suggestion) { create(:suggestion, translator_id: 1, translation: translation) }

      before do
        post "/locales/v1/en/test_namespace/#{translation.key}/suggestions/#{suggestion.id}/approve"
      end

      it 'marks suggestion as approved by translator' do
        expect(suggestion.approved_by.count).to eq(1)
        expect(response).to have_http_status(:success)
      end

      it 'approves only once for the same user' do
        post "/locales/v1/en/test_namespace/#{translation.key}/suggestions/#{suggestion.id}/approve"
        expect(suggestion.approved_by.count).to eq(1)
        expect(JSON.parse(response.body, symbolize_names: true))
          .to eq({ errors: { approved_by: ['has already been taken'] } })
      end
    end
  end
end