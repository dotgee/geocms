mapModule = angular.module "geocms.map", ["geocms.plugins", "geocms.projections", "geocms.baseLayer"]

mapModule.service "mapService", 
  [
    "pluginService",
    "$http",
    "projectionService",
    "baseLayerService",
    (pluginService, $http, projections, baseLayerService) ->

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
        baseLayer = baseLayerService.getBaseLayer()
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
          maxZoom: layer.max_zoom,
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
        $http.get(url
        ).success((data, status, headers, config) ->
          template = _.template(mapService.generateTemplate(data))

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

        '/api/v1/data_sources/get_feature_infos'+
        '?wms_url='+@currentLayer.data_source_wms+
        '&feature_name='+@currentLayer.name+
        '&width='+size.x+
        '&height='+size.y+
        '&bbox='+BBOX+
        '&current_x='+x+
        '&current_y='+y

      mapService.generateTemplate = (data) ->
        if mapService.currentLayer.template? and mapService.currentLayer.template != ""
          template = mapService.currentLayer.template
        else
          template = "<ul class='list-unstyled'>"
          _.each data.features[0].properties, (val, key) ->
            template += "<li>"+key+": "+val+"</li>"
          template += "</ul>"
        template
      mapService
]
