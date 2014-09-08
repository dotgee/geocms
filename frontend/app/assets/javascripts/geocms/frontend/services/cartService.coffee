cartModule = angular.module "geocms.cart", ["geocms.map", "restangular"]

cartModule.service "cartService",
  [
    "mapService",
    "Restangular",
    "$rootScope",
    (ms, Restangular, $root) ->

      Cart = ->
        @layers = []
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
          layer.opacity = 0.9

      Cart::setOpacity = (ev, ui) ->
        index = $(ui.handle).parent().data("index")
        $root.cart.layers[index]._tilelayer.setOpacity(ui.value)
        $root.cart.layers[index].opacity = ui.value

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

      Cart::addSeveral = () ->
        that = this
        console.log @context
        _.each @context.contexts_layers, (cl) ->
          that.layers.push ms.addLayer(cl)

      Cart::save = () ->
        # unless @state == "saved"
        console.log "saving..."
        console.log @context
        # @context.contexts_layer_ids = _.map(@context.contexts_layers, )
        delete @context.contexts_layers
        @context.save()

      Cart::centerOn = (layer) ->
        bbox =  new L.LatLngBounds(
                    new L.LatLng layer.bbox[0], layer.bbox[1]
                  , new L.LatLng layer.bbox[2], layer.bbox[3]
                )
        ms.container.fitBounds(bbox)

      Cart
  ]