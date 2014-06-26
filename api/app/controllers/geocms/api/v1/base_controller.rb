module Geocms
  module Api
    module V1
      class BaseController < ActionController::Base
        respond_to :json
        set_current_tenant_by_subdomain(Geocms::Account, :subdomain)
      end
    end
  end
end