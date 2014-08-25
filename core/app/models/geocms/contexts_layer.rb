module Geocms
  class ContextsLayer < ActiveRecord::Base

    belongs_to :context
    belongs_to :layer

    attr_accessible :position, :opacity, :layer_id, :context_id, :visibility

    delegate :title, :description, :name, :tiled, :template, 
             :data_source_wms, :data_source_wms_version, :data_source_not_internal,
             :data_source_ogc, :data_source_name, :bbox, to: :layer
    delegate :id, to: :layer, prefix: true
  end
end