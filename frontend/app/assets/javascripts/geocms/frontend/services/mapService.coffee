mapModule = angular.module "geocms.map", ["geocms.plugins", "geocms.projections"]

mapModule.service "mapService", ["pluginService", "$http", "projectionService", (pluginService, $http, projections) ->

  mapService = {}

  mapService.container = null
  mapService.layers = []
  mapService.crs = null
  mapService.fullscreen = false

  mapService.createMap = (id, lat, lng, zoom) ->
    options = { zoomControl: false, crs: projections.getCRS(config.crs) }
    @container = new L.Map(id, options).setView([lat, lng], zoom)
    pluginService.addPlugins(@container)

  mapService.addBaseLayer = () ->
    switch config.crs
      when "EPSG:3857"
        baseLayer = L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png')
      when "EPSG:2154"
        baseLayer = L.tileLayer.wms("http://osm.geobretagne.fr/gwc01/service/wms", {
          layers: "osm:google",
          format: 'image/png',
          transparent: true,
          continuousWorld: true,
          unloadInvisibleTiles: false
        })
    baseLayer.addTo(@container)

  mapService.addLayer = (layer) ->
    layer.opacity = 90 unless layer.opacity?
    layer._tilelayer = L.tileLayer.wms layer.data_source_wms,
      layers: layer.name,
      format: 'image/png',
      transparent: true,
      version: layer.data_source_wms_version,
      styles: layer.default_style || '',
      continuousWorld: true,
      tiled: layer.tiled,
      maxZoom: 24,
      minZoom: 3,
      opacity: (layer.opacity / 100)
    layer._tilelayer.addTo(@container)
    layer.onMap = true
    layer

  mapService.importCenter = ->
    {
      center: @container.getCenter()
      zoom: @container.getZoom()
    }

  mapService.invalidateMap = () ->
    @container.invalidateSize()

  mapService.addEventListener = (layer) ->
    $("#map").css("cursor", "crosshair")
    @currentLayer = layer
    @container.addEventListener('click', @getFeatureWMS)
  
  mapService.removeEventListener = ->
    $("#map").removeAttr('style')
    @currentLayer = null
    @container.removeEventListener('click', @getFeatureWMS)

  mapService.getFeatureWMS = (e) ->
    url = mapService.getWMSFeatureURL(e)
    $http.get(
      "/proxy.php?url="+encodeURIComponent(url)
    ).success((data, status, headers, config) ->
      template = _.template(mapService.currentLayer.template)

      L.popup({ maxWidth: 800, maxHeight: 600 })
            .setLatLng(e.latlng)
            .setContent(template(data.features[0].properties))
            .openOn(mapService.container)
    ).error (data, status, headers, config) ->

  mapService.getWMSFeatureURL = (e) ->
    BBOX = @container.getBounds().toBBoxString()
    size = @container.getSize()
    x = @container.layerPointToContainerPoint(e.layerPoint).x
    y = @container.layerPointToContainerPoint(e.layerPoint).y

    @currentLayer.data_source_wms+'?SERVICE=WMS&VERSION=1.1.1'+
      '&request=GetFeatureInfo'+
      '&query_layers='+@currentLayer.name+
      '&layers='+@currentLayer.name+
      '&BBOX='+BBOX+
      '&x='+x+'&y='+y+
      '&height='+size.y+'&width='+size.x+
      '&info_format=application/json&'+
      'SRS=CRS:84'+'&count=1'

  mapService
]
