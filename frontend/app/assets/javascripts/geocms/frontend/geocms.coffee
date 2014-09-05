geocms = angular.module( 'geocms', [
  'ui.router'
  'restangular'
  'ui.slider'
  'ui.bootstrap'
  'geocms.contexts'
  'geocms.folders'
  'geocms.map'
  'geocms.cart'
  'geocms.catalogserv'
  'geocms.catalog'
  'geocms.map_options'
  'geocms.draggable'
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
  "mapService",
  "draggableDirective"
  (Restangular, mapService, draggable) ->
    Restangular.setBaseUrl("/api/v1")
    mapService.defineProj("EPSG:2154")
]