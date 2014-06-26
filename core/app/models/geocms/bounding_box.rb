module Geocms
  class BoundingBox < ActiveRecord::Base
    include Geocms::Concerns::Projectable

    belongs_to :layer

    scope :current, -> (tenant) { where(crs: tenant.crs.value) }
    scope :leafletable, -> { where(["crs in (?)", ['EPSG:4326', 'CRS:84']]) }

    attr_accessible :crs, :maxx, :maxy, :minx, :miny

    def to_bbox
      [minx, miny, maxx, maxy]
    end

    def for_leaflet
      # No action needed if already in 4326 or CRS:84
      return to_bbox if ["EPSG:4326", "CRS:84"].include?(crs)
      # Transform box to 4326 and reverse them because the definition is longlat
      proj_box = to_coords.map { |point| proj_to_4326(crs, [point[0], point[1]]).reverse}
      proj_box.flatten
    end

    def to_coords
      ne = [maxx, maxy]
      sw = [minx, miny]
      [sw, ne]
    end

    class << self
      def create_bounding_boxes(layer, bbox)
        bbox.each do |proj|
          crs = proj[0]
          box = proj[1]["table"]["bbox"]
          box = [box[1], box[0], box[3], box[2]] if crs == "CRS:84"
          layer.bounding_boxes.create(  minx: box[0],
                                        miny: box[1],
                                        maxx: box[2],
                                        maxy: box[3],
                                        crs: crs
                                      )
        end
      end
    end

  end
end