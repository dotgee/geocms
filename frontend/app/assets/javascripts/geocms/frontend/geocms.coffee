geocms = angular.module( 'geocms', [
  'ui.router'
  'restangular'
  'ui.slider'
  'geocms.contexts'
  'geocms.map'
  'geocms.layer'
  'geocms.catalogserv'
  'geocms.catalog'
])

geocms.config [
  "$httpProvider", 
  "$stateProvider",
  "$locationProvider",
  "$urlRouterProvider",
  "RestangularProvider",
  
  ( $httpProvider,
    $stateProvider,
    $locationProvider,
    $urlRouterProvider,
    RestangularProvider ) ->

    $locationProvider.html5Mode(true)
    RestangularProvider.setDefaultHttpFields({cache: true});
]

geocms.run [ 
  "Restangular",
  "mapService"
  (Restangular, mapService) ->
    Restangular.setBaseUrl("/api/v1")
    mapService.defineProj("EPSG:2154")
]