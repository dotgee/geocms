module Geocms
  module Backend
    class SearchController < Geocms::Backend::ApplicationController

      def search
        @layers = Layer.search(params[:query]).page(params[:page])
      end

    end
  end
end