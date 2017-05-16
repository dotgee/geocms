cartModule = angular.module "geocms.cart", ["geocms.map", "restangular"]

cartModule.service "cartService",
  [
    "mapService",
    "Restangular",
    "$rootScope",
    "toaster",
    "$state",
    "$interval",
    (ms, Restangular, $root, toaster, $state, $interval) ->

      Cart = ->
        @layers = []
        @currentLayer = null
        @context = null
        @state = "saved"
        @folders = []
        @search = ""
        @player = []
        return
      
      Cart::init = () -> 
        _.each @layers, (layer, index) ->
          if !(layer.opacity?)
            layer.opacity = 90

          layer.options = {
            opacity : layer.opacity/100.0;
          } 

      Cart::toggleVisibility = (layer) ->
        if layer._tilelayer.options.opacity > 0
          layer._tilelayer.setOpacity(0)
          layer.opacity = 0
        else if layer.options? && layer.options.opacity? && layer.options.opacity > 0
          layer.opacity = layer.options.opacity*100.0;
          layer._tilelayer.setOpacity(layer.options.opacity);
        else
          layer.opacity = 90;
          layer.options.opacity = 0.9
          layer._tilelayer.setOpacity(0.9);
          
        @state = "unsaved"

      Cart::recalculateLayerZIndex = ->
        l = @layers.length
        _.each @layers, (layer, index) ->
          p = l - index - 1
          layer._tilelayer.setZIndex(p)
          layer.position = p

        @state = "unsaved"

      Cart::toggleQuery = ->
        if ms.currentLayer == @currentLayer
          ms.removeEventListener(@currentLayer)
        else
          ms.addEventListener(@currentLayer)

      Cart::setOpacity = (ev, ui,layer) ->
        layer._tilelayer.setOpacity(ui.value)
        layer.opacity = ui.value * 100
        $root.cart.state = "unsaved"

      Cart::optionSliderOpacity = (layer) -> 
        that = this
        return {
          orientation: 'horizontal',
          slide: (ev,ui) ->
            that.setOpacity(ev,ui,layer)
        }
      Cart::optionSliderTimeline = (layer) ->
        that = this
        return {
          orientation: 'horizontal', 
          slide:  (ev,ui) -> 
            that.slideTimeline(ev,ui,layer)
          ,range: 'min'}

      Cart::toggleTimeline = (layer) ->
        layer_id = layer.layer_id
        diff = layer.dimensions.length - layer.timelineIndex - 1
        that = this
        if @player[layer_id]? or diff == 0
          @stopTimeline(layer_id)
        else
          @player[layer_id] = $interval( (() ->
            thatInterval = $root.cart
            layer.timelineIndex += 1
            layer._tilelayer.setParams({time: layer.dimensions[layer.timelineIndex]})
          ) , 2000, diff)

          @player[layer_id].then ->
            that.stopTimeline(layer_id)

      Cart::stopTimeline = (layer_id) ->
        $interval.cancel($root.cart.player[layer_id])
        @player[layer_id] = null

      Cart::playTimeline = (layer) ->
        that = $root.cart
        layer.timelineIndex += 1
        layer._tilelayer.setParams({time: layer.dimensions[layer.timelineIndex]})

      Cart::slideTimeline = (ev, ui, layer) ->
        currentTime = layer.dimensions[layer.timelineIndex]
        layer._tilelayer.setParams({time: currentTime})

      Cart::remove = (layer) ->
        ms.container.removeLayer(layer._tilelayer)
        @layers.splice(@layers.indexOf(layer), 1)
        @recalculateLayerZIndex()
        @state = "unsaved"

      Cart::get = (id) ->
        layer = _.findWhere(@layers, {layer_id: id})
        @layers[@layers.indexOf(layer)]

      Cart::add = (id) ->
        that = this
        Restangular.one("layers", id).get().then (data) ->
          data.layer.position = that.layers.length+1
          that.layers.unshift ms.addLayer(data.layer)
        @state = "unsaved"

      Cart::addSeveral = () ->
        that = this
        _.each @context.contexts_layers, (cl) ->

          that.layers.push ms.addLayer(cl)

      Cart::save = () ->
        if @context.selected_folder?
          @context.folder_id = @context.selected_folder.id
          
        delete @context.contexts_layers # BUG: circular dependency in json
        
        that = this
        
        @context.contexts_layers_attributes = _.map(@layers, (cl) ->
          { id: cl.id, layer_id: cl.layer_id, opacity: cl.opacity, position: cl.position }
        )
       
        @context.save().then ((response)->
          $state.transitionTo("contexts.edit", {uuid: response.uuid}).then ->
            toaster.pop('success', "La sauvegarde a réussi", response.data)
            $root.cart.state = "saved"
        ), (response)->
          $root.settingsActive = true
          toaster.pop('error', "La sauvegarde a échoué", response.data.message)


      Cart::centerOn = (layer) ->
        bbox =  new L.LatLngBounds(
                    new L.LatLng layer.bbox[1], layer.bbox[0] # miny, minx
                  , new L.LatLng layer.bbox[3], layer.bbox[2] # maxy, maxx
                )
        ms.container.fitBounds(bbox)

      Cart::importCenter = ->
        centerInfos = ms.importCenter()
        @context.center_lng = centerInfos.center.lng
        @context.center_lat = centerInfos.center.lat
        @context.zoom = centerInfos.zoom
        @context.miny = centerInfos.bounds.getSouthWest().lat
        @context.minx = centerInfos.bounds.getSouthWest().lng
        @context.maxy = centerInfos.bounds.getNorthEast().lat
        @context.maxx = centerInfos.bounds.getNorthEast().lng
      Cart
  ]