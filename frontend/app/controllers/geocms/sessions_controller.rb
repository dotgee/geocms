module Geocms
  class SessionsController < Devise::SessionsController
    layout 'geocms/layouts/geocms_login'
    set_current_tenant_by_subdomain(Geocms::Account, :subdomain)


    def create
      super do |resource|
        if resource.errors.any?
          raise resource.errors.inspect
        end
      end
    end

    #
    # # skip_before_action :require_login
    #
    # def new
    #   redirect_back_or_to root_url if logged_in?
    # end
    #
    # def create
    #   user = login(params[:username], params[:password], params[:remember_me])
    #   if user && current_tenant.users.find_by_username(params[:username])
    #     redirect_back_or_to root_url, :success => t("session.logged_in")
    #   else
    #     redirect_to login_path, :flash => { :error => t("session.invalid_credentials") }
    #   end
    # end
    #
    # def destroy
    #   logout
    #   redirect_to root_url, :notice => "Logged out!"
    # end
  end
end
