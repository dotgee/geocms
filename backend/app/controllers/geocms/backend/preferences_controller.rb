module Geocms
  module Backend
    class PreferencesController < Geocms::Backend::ApplicationController
      load_and_authorize_resource class: "Geocms::Preference"
      
      rescue_from CanCan::AccessDenied do |exception|
        controle_access()
      end
      
      def edit
      end

      def update
        preference_params.each do |p|
          ActsAsTenant.current_tenant.write_preference(p[0], p[1])
        end if preference_params

        ActsAsTenant.current_tenant.update_attributes(params[:account]) if params[:account]

        respond_with(:edit, :backend,  :preferences)
      end

      private
        def preference_params
          params.require(:preferences).permit(PermittedAttributes.preference_attributes)
        end
    end
  end
end
