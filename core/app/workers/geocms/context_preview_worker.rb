module Geocms
  class ContextPreviewWorker
    include Sidekiq::Worker
    include Rails.application.routes.url_helpers

    def perform(context, url)
      t = Tempfile.new([context["uuid"], ".png"])
      t.binmode
      #TODO
      #catch errors
      cmd = "phantomjs #{Rails.root}/script/thumbnail.js #{url_for_context(context, url)} #{t.path}"
      puts cmd
      `#{cmd}`

      t.rewind
      ctx = Context.find(context["id"])
      ctx.preview = t
      Context.skip_callback(:save, :after, :generate_preview)
      ctx.save
    end

    private
      def url_for_context(context, url)
        #mettre en place une configuration d'url
        return url + share_context_path({ id: context["uuid"] })
      end
  end
end