# frozen_string_literal: true

module TranslationManager
  class TranslationsController < ApplicationController
    def index
      render json: Translation.where(permitted_params).pluck(:key, :value).to_h.to_json
    end

    def stale
      render json:
        Translation.where(permitted_params.merge({ stale: true })).pluck(:key, :value).to_h.to_json
    end

    def import
      translation_import = Import.new(namespace: params[:namespace])
      tempfile = Tempfile.new('translations.yml').tap do |f|
        f << request.body
        f.close
      end
      translation_import.file.attach(
        io: tempfile.open,
        filename: 'translations.yml',
        content_type: 'application/yml'
      )
      translation_import.save!
      tempfile.unlink
      ImportJob.perform_later(translation_import.id)
      render json: { translation_import_id: translation_import.id }
    end

    private

    def permitted_params
      params.permit(:language, :namespace, :version)
    end
  end
end
