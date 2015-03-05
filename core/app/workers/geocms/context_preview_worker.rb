module Geocms
  class ContextPreviewWorker
    include Sidekiq::Worker

    def perform(context_id, current_tenant_id)
      current_tenant = Geocms::Account.find current_tenant_id
      context = Geocms::Context.find context_id
      context.remote_preview_url = "#{current_tenant.screenshot_url.value}?url=#{current_tenant.host.value}#{context.share_url}?plugins&delay=15000"
      context.save!
    end

  end
end