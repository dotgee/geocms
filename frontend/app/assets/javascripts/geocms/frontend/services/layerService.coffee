layerModule = angular.module "geocms.layer", ["geocms.map"]

layerModule.service "layerService",
  [ "mapService", (ms) ->

    layerService = {}

    layerService.toggleVisibility = (layer) ->
      if layer._tilelayer.options.opacity > 0
        layer._tilelayer.setOpacity(0)
      else
        layer._tilelayer.setOpacity(0.9)

    layerService.setOpacity = (ev, ui) ->
      index = $(ui.handle).parent().data("index")
      ms.layers[index]._tilelayer.setOpacity(ui.value)

    layerService.remove = (layer) ->
      ms.container.removeLayer(layer._tilelayer)
      ms.layers.splice(ms.layers.indexOf(layer), 1)

    layerService.centerOn = (layer) ->
      bbox =  new L.LatLngBounds(
                  new L.LatLng layer.bbox[0], layer.bbox[1]
                , new L.LatLng layer.bbox[2], layer.bbox[3]
              )
      ms.container.fitBounds(bbox)

    layerService
  ]