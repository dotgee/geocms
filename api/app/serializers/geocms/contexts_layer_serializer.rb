module Geocms
  class ContextsLayerSerializer < ActiveModel::Serializer

    attributes :id, :opacity, :layer_id, :title, :description, :name, :tiled, :template, 
               :data_source_wms, :data_source_wms_version, :data_source_not_internal,
               :data_source_ogc, :data_source_name, :bbox, :position, :dimensions, :metadata_url, :max_zoom
    # has_one :layer

    def bbox
      object.layer.boundingbox
    end

    def dimensions
      object.layer.dimensions.map(&:value)
    end

  end
end