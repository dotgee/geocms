module Geocms
  class ReadDataSource
    include Interactor

    # Context is the wms URL
    def call
      get_capabilities
      format_response unless context.state == "failed"
      context
    end

    private

    def get_capabilities
      begin
        wms_client = ROGC::WMSClient.new(context.url)
        capabilities = wms_client.capabilities
        context.layers = capabilities.capability.layers
      rescue
        context.state = "failed"
      end
    end

    def format_response
      context.layers = context.layers.map do |layer|
        ROGC::LayerPresenter.new(layer)
      end
    end
  end
end