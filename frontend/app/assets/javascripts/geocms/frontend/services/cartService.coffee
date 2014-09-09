cartModule = angular.module "geocms.cart", ["geocms.map", "restangular"]

cartModule.service "cartService",
  [
    "mapService",
    "Restangular",
    "$rootScope",
    (ms, Restangular, $root) ->

      Cart = ->
        @layers = []
        @currentLayer = null
        @context = null
        @state = "saved"
        @folders = []
        return

      Cart::toggleVisibility = (layer) ->
        if layer._tilelayer.options.opacity > 0
          layer._tilelayer.setOpacity(0)
          layer.opacity = 0
        else
          layer._tilelayer.setOpacity(0.9)
          layer.opacity = 90

      Cart::setOpacity = (ev, ui) ->
        index = $(ui.handle).parent().data("index")
        $root.cart.layers[index]._tilelayer.setOpacity(ui.value)
        $root.cart.layers[index].opacity = ui.value * 100

      Cart::remove = (layer) ->
        ms.container.removeLayer(layer._tilelayer)
        @layers.splice(@layers.indexOf(layer), 1)
        @currentLayer = null

      Cart::get = (id) ->
        layer = _.findWhere(@layers, {layer_id: id})
        @layers[@layers.indexOf(layer)]

      Cart::add = (id) ->
        that = this
        Restangular.one("layers", id).get().then (data) ->
          that.layers.push ms.addLayer(data.layer)

      Cart::addSeveral = () ->
        that = this
        _.each @context.contexts_layers, (cl) ->
          that.layers.push ms.addLayer(cl)

      Cart::save = () ->
        delete @context.contexts_layers # BUG: circular dependency in json
        @context.contexts_layers_attributes = _.map(@layers, (cl) ->
          { id: cl.id, layer_id: cl.layer_id, opacity: cl.opacity }
        )
        @context.save()

      Cart::centerOn = (layer) ->
        bbox =  new L.LatLngBounds(
                    new L.LatLng layer.bbox[0], layer.bbox[1]
                  , new L.LatLng layer.bbox[2], layer.bbox[3]
                )
        ms.container.fitBounds(bbox)

      Cart
  ]