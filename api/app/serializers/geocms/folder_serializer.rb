module Geocms
  class FolderSerializer < ActiveModel::Serializer
    attributes :id, :name

    has_many :contexts, embed: :objects
  end
end
