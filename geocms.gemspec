# encoding: UTF-8
version = File.read(File.expand_path('../GEOCMS_VERSION',__FILE__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'geocms'
  s.version     = version
  s.summary     = 'Full-stack geospatial vizualisation platform for Ruby on Rails.'
  s.description = 'GeoCMS is an open source geospatial vizualisation platform for Ruby on Rails.'

  s.files        = Dir['README.md', 'lib/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'
  s.required_ruby_version     = '>= 1.9.3'
  s.required_rubygems_version = '>= 1.8.23'

  s.author       = 'Jérôme Chapron'
  s.email        = 'jchapron@dotgee.fr'
  s.homepage     = 'http://www.dotgee.fr'
  s.license      = %q{CeCiLL}

  s.add_dependency 'geocms_frontend', version
  s.add_dependency 'geocms_core', version
  s.add_dependency 'geocms_api', version
  s.add_dependency 'geocms_backend', version
end
