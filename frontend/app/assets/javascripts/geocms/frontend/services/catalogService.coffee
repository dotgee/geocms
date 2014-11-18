catalogModule = angular.module "geocms.catalogserv", ["restangular", "geocms.cart"]

catalogModule.service "catalogService", 
[
  "Restangular",
  "$state",
  (Restangular, $state) ->
    
    Catalog = ->
      @currentCategory = null
      @categoryTree = []
      @categories = []
      @layers = []
      @query = null
      return

    Catalog::getCategory = (category) ->
      return if @currentCategory == category
      @currentCategory = category
      @breadcrumb(category)
      that = this
      Restangular.one("categories", category.id).get().then (category) ->
        that.categories = category.children
        that.layers = category.layers
      return

    Catalog::addToCart = (id, cart) ->
      if @isOnCart(id, cart) then cart.remove(cart.get(id)) else cart.add(id)
      return

    Catalog::isOnCart = (id, cart) ->
      if _.findWhere(cart.layers, {layer_id: id}) then true else false

    Catalog::roots = ->
      that = this
      Restangular.all("categories").getList().then (categories) ->
        that.categories = categories
      return

    Catalog::breadcrumb = (category) ->
      index = @categoryTree.indexOf(category)
      if index > -1
        @categoryTree.splice(index+1, Number.MAX_VALUE)
      else
        @categoryTree.push category
      return

    Catalog::goToRoot = ->
      return @close() unless @categoryTree.length > 0 or @query?
      @categoryTree = []
      @layers = []
      @categories = []
      @query = null
      @roots()

    Catalog::search = ->
      that = this
      Restangular.all("layers").customGET("search", { q: @query }).then (response) ->
        that.layers = response.layers
        that.categories = []

    Catalog::close = ->
      $state.go "^"

    Catalog
]