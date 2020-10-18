# frozen_string_literal: true

module TranslationManager
  class TranslationsController < ApplicationController
    def index
      render json:
        Translation.joins(
          'LEFT OUTER JOIN translation_manager_suggestions ON (translation_manager_suggestions.translation_manager_translation_id = translation_manager_translations.id AND translation_manager_suggestions.approved = true)'
        ).where(permitted_params).group(:key).pluck(:key, :suggestion, :value)
                   .map { |t| [t[0], t[1] || t[2]] }.to_h.to_json
    end

    def stale
      render json:
        Translation.where(permitted_params.merge({ stale: true }))
                   .map { |t| [t.key, { value: t.value, suggestions: t.suggestions.pluck(:id, :suggestion) }] }
                   .to_h.to_json
    end

    def import
      translation_import = Import.new(namespace: params[:namespace])
      tempfile = Tempfile.new('translations.yml').tap do |f|
        f << request.body
        f.close
      end
      begin
        translation_import.file.attach(
          io: tempfile.open,
          filename: 'translations.yml',
          content_type: 'application/yml'
        )
        translation_import.save!
      ensure
        tempfile.unlink
      end
      ImportJob.perform_later(translation_import.id, current_user.id)
      render json: { translation_import_id: translation_import.id }
    end

    private

    def permitted_params
      params.permit(:language, :namespace, :version)
    end
  end
end
