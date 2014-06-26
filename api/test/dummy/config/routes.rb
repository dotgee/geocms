Rails.application.routes.draw do

  mount Geocms::Api::Engine => "/"
end
