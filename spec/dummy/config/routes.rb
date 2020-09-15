Rails.application.routes.draw do
  mount TranslationManager::Engine => "/translation_manager"
end
