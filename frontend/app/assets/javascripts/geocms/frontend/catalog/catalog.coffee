catalog = angular.module "geocms.catalog", [
  'ui.router'
  'restangular'
  'geocms.map'
  'geocms.catalogserv'
]

catalog.config [ 
  "$stateProvider",
  ($stateProvider) ->
    $stateProvider
      .state 'contexts.show.catalog',
        views:
          "catalog@contexts":
            templateUrl: config.prefix_uri+"/templates/catalog/catalog.html"
            controller: "CatalogController"
      .state 'contexts.new.catalog',
        views:
          "catalog@contexts":
            templateUrl: config.prefix_uri+"/templates/catalog/catalog.html"
            controller: "CatalogController"
      .state 'contexts.edit.catalog',
        views:
          "catalog@contexts":
            templateUrl: config.prefix_uri+"/templates/catalog/catalog.html"
            controller: "CatalogController"
      .state 'contexts.root.catalog',
        views:
          "catalog@contexts":
            templateUrl: config.prefix_uri+"/templates/catalog/catalog.html"
            controller: "CatalogController"
]

catalog.controller "CatalogController", [
  "$rootScope",
  "catalogService"
  ($rootScope, Catalog) ->
    $rootScope.catalog = new Catalog() unless $rootScope.catalog?
    if $rootScope.catalog.currentCategory?
      $rootScope.catalog.getCategory($rootScope.catalog.currentCategory)
    else
      $rootScope.catalog.roots()
]