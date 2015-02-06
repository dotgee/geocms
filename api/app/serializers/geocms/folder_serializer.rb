module Geocms
  class FolderSerializer < ActiveModel::Serializer
    attributes :id, :name

    has_many :contexts, embed: :objects, serializer: ContextShortSerializer
  end
end
