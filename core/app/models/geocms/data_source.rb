module Geocms
  class DataSource < ActiveRecord::Base
    has_many :layers

    default_scope -> { order("name ASC") }

    def import
      wms_client = ROGC::WMSClient.new(self.wms)
      capabilities = wms_client.capabilities
      layers = capabilities.capability.layers

      layers = layers.map do |layer|
        ROGC::LayerPresenter.new(layer)
      end
      layers
    end

    validates_presence_of :name, :ogc, :wms
  end
end