module Geocms
  class BoundingBox < ActiveRecord::Base

    belongs_to :layer

    scope :current, -> (tenant) { where(crs: tenant.crs.value) }
    scope :leafletable, -> { where(["crs in (?)", ['CRS:84', 'EPSG:4326']]) }

    def to_bbox
      [minx, miny, maxx, maxy]
    end

    def to_coords
      ne = [maxx, maxy]
      sw = [minx, miny]
      [sw, ne]
    end

  end
end