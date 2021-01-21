TranslationManager::Engine.routes.draw do
  resources :translations, path: '/v:version/:language/:namespace', param: :key, constraints: { key: /[^\/]+/ } do
    collection do
      get :stale
      post :import
    end

    resources :suggestions, shallow: false do
      member do
        post :approve
        post :dislike
      end
    end
  end
end
