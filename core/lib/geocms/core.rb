module Geocms
  module Core

  end
end

require "carrierwave"
require "acts_as_tenant"
require "friendly_id"
require "ancestry"
require "acts_as_list"
require "kaminari"
require "rgeo"
# require "tire"
require "rolify"

require "protected_attributes"

require "sorcery"
require "cancan"

require 'geocms/core/version'
require 'geocms/core/engine'
require 'geocms/core/routes'
require 'geocms/preferences'