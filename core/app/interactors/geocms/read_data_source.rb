module Geocms
  class ReadDataSource
    include Interactor

    # Context is the wms URL
    def call
      wms_client = ROGC::WMSClient.new(context.url)
      capabilities = wms_client.capabilities
      layers = capabilities.capability.layers

      context.layers = layers.map do |layer|
        ROGC::LayerPresenter.new(layer)
      end
    end
  end
end