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
        views:
          "":
            templateUrl: "/templates/contexts/root.html"
          "header":
            templateUrl: "/templates/shared/header.html"
        abstract: true
      
      .state 'contexts.root',
        url: ""
        parent: "contexts"
        views: 
          "sidebar@contexts":
            templateUrl: "/templates/contexts/sidebar.html"
            controller: "ContextsController"
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
            controller: ["$scope", "mapService", "data", ($scope, mapService, data) ->
              mapService.createMap("map", data.context.center_lat, data.context.center_lng, data.context.zoom)
              mapService.addBaseLayer()
              mapService.initLayers()
            ]
        resolve: 
          data: ["Restangular", "$stateParams", "mapService", (Restangular, $stateParams, mapService) ->
            Restangular.one('contexts', $stateParams.id).get()
          ] 
]

contexts.controller "ContextsController", [
  "$scope"
  "$state"
  "data"
  "mapService"
  "layerService"

  ($scope, $state, data, mapService, layerService) ->
    
    $scope.ls = layerService
    $scope.contexts_layers = mapService.layers = data.contexts_layers

    $scope.openCatalog = () ->
      if ($state.current.name.indexOf('catalog') > -1) then $state.go "^" else $state.go ".catalog"

]