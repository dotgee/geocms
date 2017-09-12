#encoding: UTF-8

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
version = File.read(File.expand_path("../../GEOCMS_VERSION", __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "geocms_backend"
  s.version     = version
  s.authors     = ["Philippe HUET", "Jérôme CHAPRON", "dotgee"]
  s.email       = ["philippe@dotgee.fr", "jchapron@dotgee.fr", "contact@dotgee.fr"]
  s.homepage    = "http://mapsonic.dotgeeapp.com/backend"
  s.summary     = "Geocms'backend"
  s.description = "Geocms'backend"
  s.license     = "CECILL"

  s.files = Dir["{app,config,db,lib}/**/*", "CECILL-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'geocms_core', version

  s.add_dependency 'rails-assets-angularjs', "~> 1.2.18"
  s.add_dependency 'rails-assets-lodash', "2.4.1"
  s.add_dependency 'rails-assets-restangular', "1.4.0"
  s.add_dependency 'rails-assets-ng-table', "0.3.3"

  s.add_dependency "sass-rails", '>= 4.0'
  s.add_dependency "coffee-rails"
  s.add_dependency 'slim-rails', '3.1.1'
  s.add_dependency "slim", '3.0.7' 
  s.add_dependency "bootstrap-sass", '>= 3.2'
  s.add_dependency "simple_form", '>= 3.1.0.rc2'
  s.add_dependency "responders"
  s.add_dependency "ckeditor"
  s.add_dependency 'rabl', '~> 0.7.9'
  s.add_dependency "gon"

end
