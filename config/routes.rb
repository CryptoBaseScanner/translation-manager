TranslationManager::Engine.routes.draw do
  resources :translations, path: '/v:version/:language/:namespace' do
    collection do
      get :stale
      post :import
    end
    resource :suggestions
  end
end
