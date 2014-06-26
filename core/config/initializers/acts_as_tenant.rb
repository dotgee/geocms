module ActsAsTenant
  module ControllerExtensions
    def set_current_tenant_by_subdomain(tenant = :account, column = :subdomain)
      self.class_eval do
        cattr_accessor :tenant_class, :tenant_column
        attr_accessor :current_tenant
      end

      self.tenant_class = tenant.to_s.camelcase.constantize
      self.tenant_column = column.to_sym

      self.class_eval do
        before_filter { |c| c.send(:find_tenant_by_subdomain) }

        helper_method :current_tenant

        private
          def find_tenant_by_subdomain
            c = tenant_class.where(tenant_column => request.subdomains.first)
            if c.empty?
              ActsAsTenant.current_tenant = tenant_class.where(default: true).first
            else
              ActsAsTenant.current_tenant = c.first
            end
            #@current_tenant_instance = ActsAsTenant.current_tenant
          end

          # helper method to have the current_tenant available in the controller
          def current_tenant
            ActsAsTenant.current_tenant
          end
      end
    end
  end
end
