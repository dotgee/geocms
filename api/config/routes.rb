Geocms::Api::Engine.routes.draw do

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :layers, only: [:index, :show] do
        get "search", on: :collection
        get "bbox", on: :member
      end
      resources :contexts
      resources :categories
    end
  end
end
