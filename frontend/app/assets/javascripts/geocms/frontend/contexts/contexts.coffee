contexts = angular.module "geocms.contexts", [
  'ui.router'
  'restangular'
  'geocms.map'
  'geocms.layer'
]

contexts.config [ 
  "$stateProvider",
  ($stateProvider) ->
    $stateProvider
      .state 'contexts',
        url: "/maps"
        templateUrl: "/templates/contexts/root.html"
        abstract: true
      
      .state 'contexts.root',
        url: ""
        parent: "contexts"
        views: 
          "sidebar@contexts":
            templateUrl: "/templates/contexts/sidebar.html"
          "map@contexts":
            templateUrl: "/templates/contexts/map.html"
            controller: ["$scope", "mapService", ($scope, mapService) ->
              context = { center_lat: 48.331638, center_lng: -4.34526, zoom: 6 }
              mapService.createMap("map", context.center_lat, context.center_lng, context.zoom)
              mapService.addBaseLayer()
            ]

      .state 'contexts.show',
        url: "/{id:[0-9]{1,4}}"
        parent: 'contexts.root'
        views: 
          "sidebar@contexts":
            templateUrl: "/templates/contexts/sidebar.html"
            controller: "ContextsController"
          "map@contexts":
            templateUrl: "/templates/contexts/map.html"
            controller: ["$scope", "mapService", "context", ($scope, mapService, context) ->
              mapService.createMap("map", context.center_lat, context.center_lng, context.zoom)
              mapService.addBaseLayer()
              mapService.initLayers()
            ]
        resolve: 
          context: ["Restangular", "$stateParams", "mapService", (Restangular, $stateParams, mapService) ->
            Restangular.one('contexts', $stateParams.id).get()
          ] 
]

contexts.controller "ContextsController", [
  "$scope",
  "context",
  "mapService",
  "layerService"
  ($scope, context, mapService, layerService) ->
    $scope.context = context
    $scope.ls = layerService
    mapService.layers = context.layers
]