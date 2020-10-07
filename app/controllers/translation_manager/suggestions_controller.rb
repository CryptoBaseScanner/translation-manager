# frozen_string_literal: true

module TranslationManager
  class SuggestionsController < ApplicationController
    def index
      render json: Suggestion.where(translation_manager_translation_id: params[:translation_id]).to_json
    end

    def create
      Suggestion.create(
        translator_id: current_user.id,
        translation_manager_translation_id: params[:translation_id],
        suggestion: params[:suggestion]
      )
    end

    def approve
      suggestion = Suggestion.find(params[:id]).approvals.create(approved_by: current_user.id)
      render json: { errors: suggestion.errors } unless suggestion.valid?
    end

    private

    def permitted_params
      params.permit(:translation_id)
    end
  end
end