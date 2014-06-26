module Geocms
  class ContextsLayer < ActiveRecord::Base

    belongs_to :context
    belongs_to :layer

    attr_accessible :position, :opacity, :layer_id, :context_id, :visibility

  end
end