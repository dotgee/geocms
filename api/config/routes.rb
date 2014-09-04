Geocms::Core::Engine.add_routes do

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :layers, only: [:index, :show] do
        get "search", on: :collection
        get "bbox", on: :member
      end
      resources :contexts do
        get :default, on: :collection
      end
      resources :categories
      resources :folders do
        get :writable, on: :collection
      end
    end
  end
end
