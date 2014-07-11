module Geocms
  class ContextSerializer < ActiveModel::Serializer
    embed :ids, include: true

    attributes :id, :uuid, :name, :center_lat, :center_lng, :zoom
    has_many :contexts_layers
  end
end
