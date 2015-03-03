Geocms::Core::Engine.add_routes do

  root to: "pages#index"
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"

  # serve compiled templates
  get 'templates/(*template_name)', :to => 'static#template'
  # routes accessible and defined in angular app
  get '/maps(*foo)', to: "pages#index"
  get '/projects(*foo)', to: "pages#index"
end
