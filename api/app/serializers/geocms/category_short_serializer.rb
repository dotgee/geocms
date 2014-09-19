module Geocms
  class CategoryShortSerializer < ActiveModel::Serializer
    attributes :id, :name, :depth
  end
end
