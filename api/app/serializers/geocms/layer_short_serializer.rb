module Geocms
  class LayerShortSerializer < ActiveModel::Serializer
    attributes  :layer_id, :title, :description, :thumbnail_url, :data_source_name, :queryable, :dimensions

    def layer_id
      object.id
    end
    
    def dimensions
      object.dimensions.map(&:value)
    end

  end
end