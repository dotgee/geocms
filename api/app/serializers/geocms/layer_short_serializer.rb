module Geocms
  class LayerShortSerializer < ActiveModel::Serializer
    attributes  :layer_id, :title, :description, :thumbnail_url, :data_source_name

    def layer_id
      object.id
    end

  end
end