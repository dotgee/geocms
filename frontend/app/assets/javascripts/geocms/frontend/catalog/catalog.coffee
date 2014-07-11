catalog = angular.module "geocms.catalog", [
  'ui.router'
  'restangular'
  'geocms.map'
]

catalog.config [ 
  "$stateProvider",
  ($stateProvider) ->
    $stateProvider
      .state 'contexts.show.catalog',
        views:
          "catalog@contexts":
            templateUrl: "/templates/catalog/catalog.html"
            controller: "CatalogController"
      .state 'contexts.root.catalog',
        views:
          "catalog@contexts":
            templateUrl: "/templates/catalog/catalog.html"
            controller: "CatalogController"
]

catalog.controller "CatalogController", [
  "$scope",
  ($scope) ->
    console.log "hello"  
]