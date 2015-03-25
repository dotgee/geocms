mapModule = angular.module "geocms.map", ["geocms.plugins", "geocms.projections", "geocms.baseLayer"]

mapModule.service "mapService",
  [
    "pluginService",
    "$http",
    "projectionService",
    "baseLayerService",
    "$rootScope",
    "$compile",
    "$filter"
    (pluginService, $http, projections, baseLayerService, $root, $compile, $filter) ->

      mapService = {}

      mapService.container = null
      mapService.layers = []
      mapService.crs = null
      mapService.fullscreen = false

      mapService.createMap = (id, lat, lng, zoom, pluginParams) ->
        options = { zoomControl: false, crs: projections.getCRS(config.crs)}
        @container = new L.Map(id, options).setView([lat, lng], zoom)
        @container.attributionControl.setPrefix("Built with <a href='https://github.com/jchapron/geocms'>GeoCMS</a>")
        pluginService.addPlugins(@container, pluginParams)
        @addEventListener()

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
          zIndex: layer.position
        layer._tilelayer.addTo(@container)
        layer.onMap = true
        layer

      mapService.importCenter = ->
        {
          center: @container.getCenter()
          zoom: @container.getZoom()
          bounds: @container.getBounds()
        }

      mapService.invalidateMap = () ->
        @container.invalidateSize()

      mapService.addEventListener = () ->
        @container.addEventListener('click', @queryLayer, mapService)

      mapService.queryLayer = (e) ->
        html = '<div ng-include="\''+config.prefix_uri+'/templates/layers/popup.html\'"></div>'
        scope = $root.$new()
        linkFunction = $compile(html)
        @currentPosition = e.latlng
        @layerPoint = e.layerPoint
        # @container.setView(@currentPosition)
        scope.ms = this
        scope.filteredLayers = $filter('filter')(scope.cart.layers, scope.ms.greaterThan('opacity', 0.01))
        scope.filteredLayers = $filter('filter')(scope.filteredLayers, scope.ms.containsPoint())
        if scope.filteredLayers.length == 1
          scope.ms.chooseLayer(scope.filteredLayers[0])
        else
          L.popup({ className: "query-layer-switcher geocms-popup",autoPanPaddingTopLeft: new L.Point(545,200)})
                  .setLatLng(@currentPosition)
                  .setContent(linkFunction(scope)[0])
                  .openOn(@container)
        @container.on('popupclose', (e) -> scope.$destroy())
        scope.$apply()

      mapService.chooseLayer = (layer) ->
        @currentLayer = layer
        @getFeatureWMS()

      mapService.containsPoint = ->
        (item) ->
          bounds = (if (item.bbox? && item.bbox.length > 0) then L.latLngBounds(L.latLng(Math.floor(item.bbox[1] *100)/100, Math.floor(item.bbox[0] *100)/100), L.latLng(Math.ceil(item.bbox[3] *100)/100, Math.ceil(item.bbox[2] *100)/100)) else null)
          return if bounds? then bounds.contains(mapService.currentPosition) else false

      mapService.getFeatureWMS = ->
        url = mapService.getWMSFeatureURL()
        $http.get(url
        ).success((data, status, headers, config) ->
          L.popup({ maxWidth: 820, maxHeight: 620, className: "geocms-popup",autoPanPaddingTopLeft: new L.Point(545,200) })
                .setLatLng(mapService.currentPosition)
                .setContent(mapService.generateTemplate(data))
                .openOn(mapService.container)
        ).error (data, status, headers, config) ->

      mapService.getWMSFeatureURL = () ->
        size = @container.getSize()
        position = @container.layerPointToContainerPoint(@layerPoint)

        config.prefix_uri+
        '/api/v1/data_sources/get_feature_infos'+
        '?wms_url='+@currentLayer.data_source_wms+
        '&feature_name='+@currentLayer.name+
        '&width='+size.x+
        '&height='+size.y+
        '&bbox='+@container.getBounds().toBBoxString()+
        '&current_x='+position.x+
        '&current_y='+position.y

      mapService.generateTemplate = (data) ->
        _.templateSettings =
          interpolate: /\{\{(.+?)\}\}/g
        wrapper = "<div class='geocms-popup-header'><h1>"+@currentLayer.title+"</h1></div>"
        wrapper += "<div class='geocms-popup-body'>"
        if data == "null" or data.status == "failed"
          body = "<p>Impossible d'obtenir les propriétés de cette couche.</p>"
        else if data.features.length > 0
          if mapService.currentLayer.template? and mapService.currentLayer.template != ""
            html = mapService.currentLayer.template
          else
            html = "<ul class='list-unstyled'>"
            _.each data.features[0].properties, (val, key) ->
              html += "<li><strong>"+key+":</strong> "+val+"</li>"
            html += "</ul>"
          template = _.template(html)
          body = template(data.features[0].properties)
        else
          body = "<p>Pas de données sur ce point.</p>"
        wrapper + body + '</div>'
      mapService
]
