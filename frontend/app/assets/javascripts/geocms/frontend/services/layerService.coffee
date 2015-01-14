layerModule = angular.module "geocms.layer", []

layerModule.service "layerService", ["$http", "$q", ($http, $q) ->

  layerService = {}
  
  layerService.getLayer = (type, data) ->
    deffered = $q.defer()

    switch type
      when "tilelayer"
        promise = @_getTileLayer(data, deffered)
      when "geojson"
        promise = @_getGeoJSON(data, deffered)
      else
        promise = deffered.reject("Invalid/Unsupported layer type")

    return promise

  layerService._getTileLayer = (data, deffered) ->
    tileLayer = L.tileLayer.wms data.data_source_wms,
      layers: data.name,
      format: 'image/png',
      transparent: true,
      version: data.data_source_wms_version,
      styles: data.default_style || '',
      continuousWorld: true,
      tiled: data.tiled,
      maxZoom: data.max_zoom,
      minZoom: 3,
      opacity: (data.opacity / 100)
    
    deffered.resolve(tileLayer)
    deffered.promise

  layerService._getGeoJSON = (data, deffered) ->
    url = @_buildGeoJsonUrl(data)
    proj4.defs("EPSG:3857","+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs");
    $http.jsonp(url)
      .success (geojson) ->
        deffered.resolve(L.Proj.geoJson(geojson))
      .error (data) ->
        deffered.reject(data)

    deffered.promise

  layerService._buildGeoJsonUrl = (data) ->
    defaultParameters =
      service: 'WFS',
      version: '1.1.0',
      request: 'GetFeature',
      typeName: data.name,
      srsName: config.crs,
      outputFormat: 'text/javascript',
      format_options: 'callback:JSON_CALLBACK'
    data.data_source_wms + L.Util.getParamString(defaultParameters)

  return layerService

]