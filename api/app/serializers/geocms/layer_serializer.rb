module Geocms
  class LayerSerializer < ActiveModel::Serializer
    embed :ids, include: true

    attributes  :layer_id, :title, :description, :name, :tiled, :template,
                :data_source_wms, :data_source_wms_version, :data_source_not_internal,
                :data_source_ogc, :data_source_name, :bbox, :dimensions, :metadata_url,
                :max_zoom

    def bbox
      object.boundingbox
    end

    def layer_id
      object.id
    end

    def dimensions
      object.dimensions.map(&:value)
    end

  end
end
