#encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
version = File.read(File.expand_path("../../GEOCMS_VERSION", __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "geocms_frontend"
  s.version     = version
  s.authors     = ["Jérôme CHAPRON", "dotgee"]
  s.email       = ["jchapron@dotgee.fr", "contact@dotgee.fr"]
  s.homepage    = "iuem.indigeo.fr"
  s.summary     = "Geocms'frontend"
  s.description = "Geocms'frontend"
  s.license     = "CECILL"

  s.files = Dir["{app,config,db,lib}/**/*", "CECILL-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'geocms_core', version
  s.add_dependency 'geocms_api', version

  s.add_dependency "sass-rails", '~> 4.0.0'
  s.add_dependency "coffee-rails", '~> 4.0.0'
  #s.add_dependency "compass-rails", "~> 1.1.2"
  s.add_dependency "slim-rails"
  #s.add_dependency 'bootstrap-sass', '~> 2.2.2.0'

  s.add_dependency 'rails-assets-jquery', "> 2.0.0"
  s.add_dependency 'rails-assets-lodash', "2.4.1"
  s.add_dependency 'rails-assets-angular', "~> 1.2.18"
  s.add_dependency 'rails-assets-restangular', "1.4.0"
  s.add_dependency 'rails-assets-angular-ui-router', "0.2.10"
  s.add_dependency 'rails-assets-angular-animate', "1.2.19"
  # s.add_dependency 'rails-assets-angular-ui-slider', '0.0.2'
  s.add_dependency 'rails-assets-masonry', '3.1.5'
  s.add_dependency 'rails-assets-angular-masonry', '0.9.1'
  s.add_dependency 'rails-assets-leaflet', "0.7.3"
  s.add_dependency 'rails-assets-proj4', "~> 1.3.4"
  # Waiting for proj4leaflet to be compatible
  # s.add_dependency 'rails-assets-proj4leaflet', "0.7.0"
  s.add_dependency 'rails-assets-moment', "2.7.0"


end
