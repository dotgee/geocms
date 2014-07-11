module Geocms
  class ContextsLayerSerializer < ActiveModel::Serializer
    embed :objects

    attributes :id, :opacity
    has_one :layer
  end
end