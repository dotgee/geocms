mapOptionModule = angular.module "geocms.map_options", ["restangular"]

mapOptionModule.service "mapOptionService",
  [
    "mapService",
    "Restangular",
    "$rootScope",
    (ms, Restangular, $root) ->
      mapOptions = {}

      mapOptions.greaterThan = (prop, val) ->
        (item) ->
          return true if (item[prop] > val)

      mapOptions.centerMap = () ->
        ms.container.setView([$root.cart.context.center_lat, $root.cart.context.center_lng], $root.cart.context.zoom)

      mapOptions.fullscreen = () ->
        ms.fullscreen = !ms.fullscreen
        setTimeout (->
          ms.invalidateMap()
          return
        ), 1000

      mapOptions
  ]