catalogModule = angular.module "geocms.catalogserv", ["restangular"]

catalogModule.service "catalogService", ["Restangular", (Restangular) ->
  
  Catalog = ->
    @currentCategory = null
    @categoryTree = []
    @categories = []
    @layers = []
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
    @categoryTree = []
    @layers = []
    @categories = []
    @roots()

  Catalog
]