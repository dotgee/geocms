projectionModule = angular.module "geocms.projections", []

# This module is used to choose the projection you want to use on your geocms
# account. By default, GeoCMS supports EPSG:3857, EPSG:4326 and EPSG:2154
# if you need more projections, you can extend/override this service.
projectionModule.service "projectionService", [() ->

  {
    # This function takes an EPSG code as argument (string)
    # and returns the matching Leaflet CRS object
    getCRS: (code) ->
      switch code
        when "EPSG:3857"
          return L.CRS.EPSG3857
        when "EPSG:4326"
          return L.CRS.EPSG4326
        when "EPSG:2154"
          return @_defineEPSG2154()
        else
          return L.CRS.Simple

    # Define EPSG:2154 using Proj4Leaflet
    _defineEPSG2154: () ->
      scale = (zoom) ->
        return 1 / (4891.96875 / Math.pow(2, zoom))

      bbox = [-357823.236499999999, 6037008.69390000030,
              894521.034699999960, 7289352.96509999968]

      transformation = new L.Transformation(1, -bbox[0], -1, bbox[1])

      crs = L.CRS.proj4js(
        'EPSG:2154',
        '+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 
        +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs',
        transformation
      )
      crs.scale = scale
      crs
  }

]
