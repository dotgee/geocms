module Geocms
  class CategorySerializer < ActiveModel::Serializer
    has_many :layers, serializer: LayerShortSerializer 
    has_many :children, serializer: CategoryShortSerializer

    attributes :id, :name

  end
end
