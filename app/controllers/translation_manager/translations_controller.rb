# frozen_string_literal: true

module TranslationManager
  class TranslationsController < ApplicationController
    before_action :authenticate!, only: :import

    def index
      render json:
               Translation.left_outer_joins(:suggestions)
                 .where(permitted_params)
                 .where(translation_manager_suggestions: { approved: [nil, true] })
                 .pluck(:translation_key, :suggestion, :value)
                 .each_with_object({}) { |(key, suggestion, value), hash|
                   hash[key] = suggestion || value
                 }
    end

    def stale
      render json:
               Translation
                 .includes(:suggestions).where(permitted_params.merge({ stale: true }))
                 .each_with_object({}) { |t, h|
                   h[t.translation_key] = { value: t.value, suggestions: t.suggestions.pluck(:id, :suggestion) }
                 }
    end

    def import
      translation_import = Import.create(namespace: params[:namespace], file: request.body)

      ImportJob.perform_later(translation_import.id, current_user.id)
      render json: { translation_import_id: translation_import.id }
    end

    private

    def permitted_params
      params.permit(:language, :namespace, :version)
    end
  end
end
