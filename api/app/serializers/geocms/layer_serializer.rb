module Geocms
  class LayerSerializer < ActiveModel::Serializer
    attributes :id, :title, :description, :name, :tiled, :template
  end
end
