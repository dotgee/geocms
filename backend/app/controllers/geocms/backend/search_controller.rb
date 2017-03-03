module Geocms
  module Backend
    class SearchController < Geocms::Backend::ApplicationController
      load_and_authorize_resource class: "Geocms::Search"

      rescue_from CanCan::AccessDenied do |exception|
        controle_access()
      end

      def search
        @layers = current_tenant.layers.search(params[:query]).page(params[:page])
      end

    end
  end
end