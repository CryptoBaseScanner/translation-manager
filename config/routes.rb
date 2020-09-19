TranslationManager::Engine.routes.draw do
  get '/v:version/:language/:namespace', to: 'locales#show', as: :locale
  post '/:language/:namespace/import', to: 'locales#import', as: :locale_import
end
