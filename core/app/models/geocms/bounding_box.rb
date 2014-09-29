module Geocms
  class BoundingBox < ActiveRecord::Base
    include Geocms::Concerns::Projectable

    belongs_to :layer

    scope :current, -> (tenant) { where(crs: tenant.crs.value) }
    scope :leafletable, -> { where(["crs in (?)", ['EPSG:4326', 'CRS:84']]) }

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

  end
end