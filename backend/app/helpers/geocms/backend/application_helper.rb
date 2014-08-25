module Geocms
  module Backend::ApplicationHelper
    def logo_for_tenant(tenant = current_tenant)
      url = (tenant && tenant.logo?) ? tenant.logo : "geocms/dotgeocms.png"
      image_tag url
    end

    def share_link(iframe = false)
      (iframe ? "<iframe src='" : "") + "#{request.protocol}#{request.host_with_port}#{ENV["PREFIX"]}"
    end

    def geovisu_link
      "#{request.protocol}#{request.host_with_port}/geovisu/?wmc=#{share_link}/"
    end

    def breadcrumb_for_category(category = nil, admin = false)
      tpl = admin ? "geocms/parts/backend_breadcrumb" : "geocms/parts/breadcrumb"
      render tpl, :category => category
    end
  end
end