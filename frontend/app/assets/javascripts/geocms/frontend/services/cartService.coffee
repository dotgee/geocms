cartModule = angular.module "geocms.cart", ["geocms.map", "restangular"]

cartModule.service "cartService", 
  [ 
    "mapService",
    "Restangular",
    "$rootScope",
    (ms, Restangular, $root) ->
    
      Cart = ->
        @layers = []
        return

      Cart::toggleVisibility = (layer) ->
        if layer._tilelayer.options.opacity > 0
          layer._tilelayer.setOpacity(0)
        else
          layer._tilelayer.setOpacity(0.9)

      Cart::setOpacity = (ev, ui) ->
        index = $(ui.handle).parent().data("index")
        $root.cart.layers[index]._tilelayer.setOpacity(ui.value)

      Cart::remove = (layer) ->
        ms.container.removeLayer(layer._tilelayer)
        @layers.splice(@layers.indexOf(layer), 1)
        layer.onMap = false

      Cart::get = (id) ->
        layer = _.findWhere(@layers, {id: id})
        @layers[@layers.indexOf(layer)]

      Cart::add = (id) ->
        that = this
        Restangular.one("layers", id).get().then (data) ->
          that.layers.push ms.addLayer(data.layer)

      Cart::addSeveral = (context_layers) ->
        that = this
        _.each context_layers, (cl) ->
          that.layers.push ms.addLayer(cl)


      Cart::centerOn = (layer) ->
        bbox =  new L.LatLngBounds(
                    new L.LatLng layer.bbox[0], layer.bbox[1]
                  , new L.LatLng layer.bbox[2], layer.bbox[3]
                )
        ms.container.fitBounds(bbox)

      Cart
  ]