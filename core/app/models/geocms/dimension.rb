module Geocms
  class Dimension < ActiveRecord::Base
    belongs_to :layer

    default_scope -> { order("value ASC") }

    validates :layer_id, presence: true
    validates :value, uniqueness: { scope: :layer_id }

    class << self
      def create_dimension_values(layer, values)
        values = values.split(',') unless values.is_a?(Array)

        values.each do |val|
          layer.dimensions.create(value: val)
        end
        # self.save
      end
    end
  end
end