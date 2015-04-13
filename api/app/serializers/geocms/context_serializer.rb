module Geocms
  class ContextSerializer < ActiveModel::Serializer
    attributes :id, :uuid, :name, :center_lat, :center_lng, :zoom, :preview_url,
               :description, :slug, :editable, :direct_link, :embed_code
    has_many :contexts_layers, serializer: ContextsLayerSerializer, embed: :objects

    def editable
      Geocms::Ability.new(scope[:user], scope[:account]).can?(:update, object)
    end

    def direct_link
      "#{scope[:account].host.value}#{scope[:account].prefix_uri.value}/maps/#{uuid}/share"
    end

    def embed_code
      "<iframe width='100%' height='500px' frameBorder='0' src='#{direct_link}'></iframe>"
    end

  end
end
