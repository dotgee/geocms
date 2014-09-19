Geocms::Core::Engine.add_routes do

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      
      resources :layers, only: [:index, :show] do
        get "search", on: :collection
        get "bbox", on: :member
        post "import", on: :collection
      end
      
      resources :contexts do
        get :default, on: :collection
        get :wmc, on: :member
      end
      
      resources :categories do
        get :ordered, on: :collection
      end
      
      resources :folders do
        get :writable, on: :collection
      end

      resources :data_sources, only: [] do
        get :capabilities, on: :member
      end

    end
  end
end
