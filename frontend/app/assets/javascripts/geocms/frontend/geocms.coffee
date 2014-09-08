geocms = angular.module( 'geocms', [
  'ui.router'
  'restangular'
  'ui.slider'
  'ui.tree'
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

    $urlRouterProvider.when('', '/maps');
    $urlRouterProvider.when('/', '/maps');
]

geocms.run [
  "Restangular"
  "mapService"
  (Restangular, mapService, draggable) ->
    Restangular.setBaseUrl("/api/v1")
    mapService.defineProj("EPSG:2154")

    # TODO: find a better way
    # This is a little hacky
    # Before sending the object to the server i need to wrap it in an object
    # of the same name
    # eg : context: { ... } instead of { ... }
    # by default restangular sends it as a hash with the attributes, which is not
    # what rails strong parameters expect
    # if you find a way around it you can delete undescore singularize which is only
    # used here.
    Restangular.addRequestInterceptor (element, operation, what, url) ->
      obj = {}
      obj[_.singularize(what)] = element
      element = obj
]