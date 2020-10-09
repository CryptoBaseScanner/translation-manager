TranslationManager::Engine.routes.draw do
  resources :translations do
    resources :suggestions, shallow: true do
      member do
        post :approve
      end
    end
  end

  resources :translations, path: '/v:version/:language/:namespace' do
    collection do
      get :stale
      post :import
    end
  end
end
