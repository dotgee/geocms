module Geocms
  class ContextShortSerializer < ActiveModel::Serializer
    attributes :id, :uuid, :name, :description
  end
end