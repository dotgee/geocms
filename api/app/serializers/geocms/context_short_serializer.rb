module Geocms
  class ContextShortSerializer < ActiveModel::Serializer
    attributes :id, :uuid, :name, :description, :preview_url
  end
end