module Geocms
  class ContextSerializer < ActiveModel::Serializer
    attributes :id, :uuid, :name, :center_lat, :center_lng, :zoom
    has_many :layers
  end
end
