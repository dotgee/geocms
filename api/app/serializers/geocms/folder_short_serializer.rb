module Geocms
  class FolderShortSerializer < ActiveModel::Serializer
    attributes :id, :slug, :name, :visibility
  end
end
