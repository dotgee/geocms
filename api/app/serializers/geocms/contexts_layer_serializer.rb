module Geocms
  class ContextsLayerSerializer < ActiveModel::Serializer

    attributes :id, :opacity, :layer_id, :title, :description, :name, :tiled, :template, 
               :data_source_wms, :data_source_wms_version, :data_source_not_internal,
               :data_source_ogc, :data_source_name, :bbox, :position
    # has_one :layer

    def bbox
      object.layer.boundingbox(scope)
    end

  end
end