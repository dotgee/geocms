module Geocms
  module Backend
    class Engine < ::Rails::Engine
      isolate_namespace Geocms
      engine_name "geocms_backend"
    end
  end
end