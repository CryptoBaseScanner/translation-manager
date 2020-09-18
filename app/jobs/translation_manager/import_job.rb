# frozen_string_literal: true

module TranslationManager
  class ImportJob < ApplicationJob
    def perform(import_id)
      Import.find(import_id).import!
    end
  end
end
