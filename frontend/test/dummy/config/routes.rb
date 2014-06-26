Rails.application.routes.draw do

  mount Geocms::Frontend::Engine => "/"
end
