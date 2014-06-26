module Geocms
  module Api
    class Engine < ::Rails::Engine
      isolate_namespace Geocms
      engine_name "geocms_api"
    end
  end
end