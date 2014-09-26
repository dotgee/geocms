module Geocms
  class ContextSerializer < ActiveModel::Serializer
    attributes :id, :uuid, :name, :center_lat, :center_lng, :zoom, :preview_url,
               :description, :slug, :editable
    has_many :contexts_layers, serializer: ContextsLayerSerializer, embed: :objects

    def editable
      Geocms::Ability.new(scope).can?(:update, object)
    end

  end
end
