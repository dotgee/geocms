module Geocms
  class LayerSerializer < ActiveModel::Serializer
    attributes  :id, :title, :description, :name, :tiled, :template, 
                :data_source_wms, :data_source_wms_version, :data_source_not_internal,
                :data_source_ogc, :data_source_name, :bbox

    def bbox
      object.boundingbox(current_tenant)
    end

  end
end
