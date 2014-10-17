baseLayerModule = angular.module "geocms.baseLayer", []

baseLayerModule.service "baseLayerService", [ ->

  baseLayerService = {}
  
  baseLayerService.getBaseLayer = ->
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
    baseLayer

  baseLayerService

]