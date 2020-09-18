Rails.application.routes.draw do
  mount TranslationManager::Engine => "/locales"
end
