# frozen_string_literal: true

module TranslationManager
  class SuggestionsController < ApplicationController
    before_action :authenticate!, only: [:create, :approve]

    def index
      render json: Suggestion.where(
        translation: Translation.where(permitted_params)
      )
    end

    def create
      Translation.find_by(permitted_params).suggestions.create(
        translator_id: current_user.id,
        suggestion:    params[:suggestion]
      )
    end

    def approve
      suggestion = Suggestion.find(params[:id]).approvals.create(approved_by: current_user.id)
      render json: { errors: suggestion.errors } unless suggestion.valid?
    end

    def dislike
      suggestion = Suggestion.find(params[:id]).dislikes.create(disliked_by: current_user.id)
      render json: { errors: suggestion.errors } unless suggestion.valid?
    end

    private

    def permitted_params
      params.permit(:language, :namespace, :version, :translation_key)
    end
  end
end
