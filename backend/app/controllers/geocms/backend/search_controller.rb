module Geocms
  module Backend
    class SearchController < Geocms::Backend::ApplicationController

      def search
        @layers = Layer.search(params)
      end

    end
  end
end