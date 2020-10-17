# frozen_string_literal: true

module TranslationManager
  class TranslationsController < ApplicationController
    def index
      render json:
        Translation.from(
          Translation.left_joins(suggestions: [:approvals]).where(permitted_params)
            .group('translation_manager_suggestions.suggestion')
            .select('*',
                    'count(translation_manager_approvals.translation_manager_suggestion_id) as approvals_count')
            .order('approvals_count DESC')
        )
                   .group('key').pluck(:key, :suggestion, :value, :approvals_count)
                   .map { |t| [t[0], t[3].zero? ? t[2] : t[1]] }.to_h.to_json
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
