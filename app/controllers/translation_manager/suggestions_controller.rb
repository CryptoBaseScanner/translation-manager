# frozen_string_literal: true

module TranslationManager
  class SuggestionsController < ApplicationController
    def index
      render json: Suggestion.where(
        translation: Translation.where(permitted_params.merge(key: params[:translation_id]))
      )
    end

    def create
      Translation.find_by(permitted_params.merge(key: params[:translation_id])).suggestions.create(
        translator_id: current_user.id,
        suggestion: params[:suggestion]
      )
    end

    def approve
      suggestion = Suggestion.find(params[:id]).approvals.create(approved_by: current_user.id)
      render json: { errors: suggestion.errors } unless suggestion.valid?
    end

    private

    def permitted_params
      params.permit(:language, :namespace, :version)
    end
  end
end