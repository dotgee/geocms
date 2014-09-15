class ReadDataSource
  include Interactor

  # Context is the wms URL
  def call
    wms_client = ROGC::WMSClient.new(context)
    capabilities = wms_client.capabilities
    layers = capabilities.capability.layers

    layers = layers.map do |layer|
      ROGC::LayerPresenter.new(layer)
    end
    layers
  end
end