module Geocms
  class FolderShortSerializer < ActiveModel::Serializer
    attributes :slug, :name, :visibility
  end
end
