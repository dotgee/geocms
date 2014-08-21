module Geocms
  module Backend
    class PreferencesController < Geocms::Backend::ApplicationController

      def edit
      end

      def update
        params[:preferences].each do |p|
          ActsAsTenant.current_tenant.write_preference(p[0], p[1])
        end if params[:preferences]

        ActsAsTenant.current_tenant.update_attributes(params[:account]) if params[:account]

        respond_with([:edit, :backend,  :preferences])
      end

    end
  end
end