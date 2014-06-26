module Geocms
  module Concerns::Projectable
    extend ActiveSupport::Concern

    included do
      EPSG_2154 = RGeo::CoordSys::Proj4.create("+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
      EPSG_4326 = RGeo::CoordSys::Proj4.create("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

      # Takes a projection and a coordinate and transform it to 4326
      # from_proj : String
      # point : Array[x, y]
      def proj_to_4326(from_proj, point)
        RGeo::CoordSys::Proj4.transform_coords(EPSG_2154, EPSG_4326, point[0], point[1])
      end

    end
  end
end