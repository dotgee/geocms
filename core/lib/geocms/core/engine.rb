module Geocms
  module Core
    class Engine < ::Rails::Engine
      isolate_namespace Geocms
    end
  end
end