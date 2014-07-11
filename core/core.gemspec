$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
version = File.read(File.expand_path("../../GEOCMS_VERSION", __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "geocms_core"
  s.version     = version
  s.authors     = ["Jérôme CHAPRON", "dotgee"]
  s.email       = ["jchapron@dotgee.fr", "contact@dotgee.fr"]
  s.homepage    = "iuem.indigeo.fr"
  s.summary     = "Core components to handle geospatial data from gis web servers"
  s.description = "Core components to handle geospatial data from gis web servers"
  s.license     = "CECILL"

  s.files = Dir["{app,config,db,lib}/**/*", "CECILL-LICENSE", "Rakefile", "README.rdoc"]
  s.require_path = 'lib'
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.0.0"
  s.add_dependency "compass-rails"
  s.add_dependency "bootstrap-sass", "~> 2.2.2"
  s.add_dependency "acts_as_tenant", '~> 0.3.5'
  s.add_dependency "friendly_id"
  s.add_dependency "ancestry"
  s.add_dependency "acts_as_list", "~> 0.4.0"
  s.add_dependency 'carrierwave', '~> 0.10.0'
  s.add_dependency "rmagick", '~> 2.13.2'
  s.add_dependency "cancan"
  s.add_dependency "rolify"
  s.add_dependency "rgeo"
  # s.add_dependency "tire"
  s.add_dependency "sorcery"
  s.add_dependency "kaminari"
  
  # Rails 4 compatibility
  s.add_dependency 'protected_attributes'
end
