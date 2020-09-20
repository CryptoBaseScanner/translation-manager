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
end
