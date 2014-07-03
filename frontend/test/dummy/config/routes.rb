Rails.application.routes.draw do
  mount Geocms::Api::Engine => "/"
  mount Geocms::Frontend::Engine => "/"
end
