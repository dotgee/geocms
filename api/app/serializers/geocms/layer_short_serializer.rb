module Geocms
  class LayerShortSerializer < ActiveModel::Serializer
    attributes  :id, :title, :description, :thumbnail_url, :data_source_name

  end
end