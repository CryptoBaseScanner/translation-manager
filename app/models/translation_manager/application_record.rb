# frozen_string_literal: true

module TranslationManager
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
