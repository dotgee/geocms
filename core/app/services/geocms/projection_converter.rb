module Geocms
  class ProjectionConverter

    EPSG_2154 = RGeo::CoordSys::Proj4.new("+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
    EPSG_4326 = RGeo::CoordSys::Proj4.new("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

    CRS_84 = RGeo::CoordSys::Proj4.new("+proj=longlat +datum=WGS84 +no_defs ")


    # from CRS 84
    def initialize(proj, point = [])
      @new_proj = proj
      @point = point
    end

    def project
      case @new_proj
      when "EPSG:4326"
        proj_to_4326
      when "EPSG:2154"
        proj_to_2154
      else
        @point
      end
    end

    def proj_to_4326
      RGeo::CoordSys::Proj4.transform_coords(CRS_84, EPSG_4326, @point[0], @point[1])
    end

    def proj_to_2154
      RGeo::CoordSys::Proj4.transform_coords(CRS_84, EPSG_2154, @point[0], @point[1])
    end



    def bbox
      case @new_proj
      when "EPSG:4326"
        [-180.0000, -90.0000, 180.0000, 90.0000]
      when "EPSG:2154"
        [-357823.2365, 6037008.6939, 1313632.3628, 7230727.3772]
      else
        [-20026376.39, -20048966.10, 20026376.39, 20048966.10]
      end
    end

  end
end