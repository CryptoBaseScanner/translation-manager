module TranslationManager
  class Engine < ::Rails::Engine
    isolate_namespace TranslationManager
  end

  def self.setup(&block)
    @config ||= TranslationManager::Engine::Configuration.new
    yield @config if block
    @config
  end

  def self.config
    Rails.application.config
  end

  def self.base_controller
    if config.respond_to?(:translation_base_controller)
      config.translation_base_controller.constantize
    else
      ::ApplicationController
    end
  end
end
