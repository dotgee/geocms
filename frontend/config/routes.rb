Geocms::Core::Engine.append_routes do
  # serve compiled templates
  get 'templates/(*template_name)', :to => 'static#template'
  # controller to match all, routes being handled by angularjs
  root to: "pages#index"
  get '/maps(*foo)', to: "pages#index"
  get '/projects(*foo)', to: "pages#index"
end
