module Geocms
  module Frontend
    class Engine < ::Rails::Engine
      isolate_namespace Geocms
      engine_name "geocms_frontend"
    end
  end
end