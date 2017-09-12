module Geocms
  class LayerThumbnailWorker
    include Sidekiq::Worker

    def perform(layer_id, data_source, crs, bbox)
      layer = Geocms::Layer.find layer_id
      layer.remote_thumbnail_url = ROGC::WMSClient.get_map(data_source, layer.name, bbox, 64, 64, crs)  
      layer.save!
    end

  end
end
