Geocms::Core::Engine.add_routes do

  get "logout" => "backend/sessions#destroy", :as => "logout"
  get "login" => "backend/sessions#new", :as => "login"
  resources :users, :only => [:new, :create]

  namespace :backend do
    root :to => "categories#index"
    
    resources :sessions, :only => [:new, :create, :destroy]

    get "search", :to => "search#search"

    resources :categories do
      member do
        get "move", :to => "categories#move"
      end
      resources :layers
    end

    resources :layers, :only => [:create, :edit, :update, :new, :destroy] do
      member do
        get "getfeatures", :to => "layers#getfeatures"
      end
    end

    resources :data_sources do
      member do
        get "import"
      end
    end

    resources :preferences, :only => [] do
      collection do
        get "edit"
        put "update"
      end
    end

    resources :users, :only => [:index, :new, :create, :edit, :update, :destroy] do
      collection do
        get "network"
        post "add"
      end
    end

    resources :accounts, :only => [:index, :new, :create, :destroy]

    resources :contexts do
      member do
        get 'refresh_preview'
      end
    end

  end
end
