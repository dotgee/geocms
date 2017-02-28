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

      resources :data_sources, only: [ :capabilitie , :get_feature_infos , :get_log_file] do
        get :capabilities, on: :member
        get :get_feature_infos, on: :collection  
        get :get_log_file, on: :collection
      end     
    end
  end
end
