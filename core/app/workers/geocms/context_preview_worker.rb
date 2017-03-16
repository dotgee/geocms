module Geocms
  class ContextPreviewWorker
    include Sidekiq::Worker

    def perform(context_id, current_tenant_id)
      puts "test on passe ici ?"
      current_tenant = Geocms::Account.find current_tenant_id
      context = Geocms::Context.find context_id
      remote_preview_url = "#{current_tenant.screenshot_url.value}?url=#{current_tenant.host.value}#{current_tenant.prefix_uri.value}#{context.share_url}?plugins&delay=15000"
      logger.info "remote url : #{remote_preview_url}"
      context.remote_preview_url = remote_preview_url
      context.save!
    end

  end
end