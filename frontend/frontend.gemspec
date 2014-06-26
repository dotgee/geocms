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
  
  s.add_dependency "compass-rails", "~> 1.1.2"
  s.add_dependency "compass", "~> 0.12.2"
  s.add_dependency "slim-rails"
  s.add_dependency 'bootstrap-sass', '~> 2.2.2.0'

  s.add_dependency 'rails-assets-angular', "1.2.18"
  s.add_dependency 'rails-assets-restangular'
  s.add_dependency 'rails-assets-leaflet', "0.7.3"
  s.add_dependency 'rails-assets-moment', "2.7.0"

end
