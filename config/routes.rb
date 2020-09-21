TranslationManager::Engine.routes.draw do
  get '/v:version/:language/:namespace', to: 'locales#show', as: :locale
  get '/v:version/:language/:namespace/stale', to: 'locales#stale', as: :locale_stale
  post '/:language/:namespace/import', to: 'locales#import', as: :locale_import
end
