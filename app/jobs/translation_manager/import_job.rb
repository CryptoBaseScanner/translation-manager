# frozen_string_literal: true

module TranslationManager
  class ImportJob < ApplicationJob
    def perform(import_id, by_user_id)
      Import.find(import_id).import!(by_user_id)
    end
  end
end
