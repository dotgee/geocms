module Geocms
  module Backend
    class ApplicationController < ActionController::Base
      before_filter :set_locale
      # self.responder = ApplicationResponder
      respond_to :html, :json


      layout 'geocms/layouts/geocms_backend'

      protect_from_forgery

      set_current_tenant_by_subdomain(Geocms::Account, :subdomain)
      before_filter :require_login

      def controle_access
        if current_user.has_any_role? :admin, :admin_instance
          redirect_to edit_backend_preferences_url :alert => ""
        else 
          redirect_to root_url, :alert => exception.message
        end
      end
      private
      def not_authenticated
        redirect_to login_url, :alert => t('session.unauthorized')
      end

      def set_locale
        session[:locale] = params[:locale] if params[:locale]
        session[:locale] ||= :fr
        I18n.locale = session[:locale]
      end

      def current_ability
        @current_ability ||= Geocms::Ability.new(current_user, current_tenant)
      end

      rescue_from CanCan::AccessDenied do |exception|
        redirect_to backend_root_url, :alert => t("access_denied")
      end
    end
  end
end