module Geocms
  class CategorySerializer < ActiveModel::Serializer
    has_many :layers, serializer: LayerShortSerializer, embed: :objects
    has_many :children, serializer: CategoryShortSerializer, embed: :objects

    attributes :id, :name

    def children
      object.children.ordered
    end

  end
end
