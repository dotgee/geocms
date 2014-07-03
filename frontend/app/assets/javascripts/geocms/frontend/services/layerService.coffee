layerModule = angular.module "geocms.layer", ["geocms.map"]

layerModule.service "layerService", ["mapService", (ms) ->
  
  layerService = {}

  layerService.toggleVisibility = (layer) ->
    if layer._tilelayer.options.opacity > 0
      layer._tilelayer.setOpacity(0)
    else
      layer._tilelayer.setOpacity(0.9)

  layerService.remove = (layer, context) ->
    ms.container.removeLayer(layer._tilelayer)
    context.layers.splice(context.layers.indexOf(layer), 1)

  layerService.centerOn = (layer) ->
    bbox =  new L.LatLngBounds(
                new L.LatLng layer.bbox[0], layer.bbox[1]
              , new L.LatLng layer.bbox[2], layer.bbox[3]
            )
    ms.container.fitBounds(bbox)

  layerService
]