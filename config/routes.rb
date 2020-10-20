TranslationManager::Engine.routes.draw do
  resources :translations, path: '/v:version/:language/:namespace' do
    collection do
      get :stale
      post :import
    end

    resources :suggestions, shallow: false do
      member do
        post :approve
      end
    end
  end
end
