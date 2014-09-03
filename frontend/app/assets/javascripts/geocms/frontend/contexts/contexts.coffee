contexts = angular.module "geocms.contexts", [
  'ui.router'
  'restangular'
  'geocms.map'
  'geocms.cart'
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
            controller: ["mapService", (mapService) ->
              context = { center_lat: 48.331638, center_lng: -4.34526, zoom: 6 }
              mapService.createMap("map", context.center_lat, context.center_lng, context.zoom)
              mapService.addBaseLayer()
            ]

      .state 'contexts.show',
        url: '/{slug}'
        parent: 'contexts.root'
        views:
          "sidebar@contexts":
            templateUrl: "/templates/contexts/sidebar.html"
            controller: "ContextsController"
          "map@contexts":
            templateUrl: "/templates/contexts/map.html"
            controller: ["mapService", "data", "folders", "$rootScope", (mapService, data, folders, $root) ->
              mapService.createMap("map", data.center_lat, data.center_lng, data.zoom)
              mapService.addBaseLayer()
              $root.cart.context = data
              $root.cart.addSeveral()
              $root.cart.folders = folders
            ]
        resolve:
          data: ["Restangular", "$stateParams", (Restangular, $stateParams) ->
            Restangular.one('contexts', $stateParams.slug).get()
          ]
          folders: ["Restangular", (Restangular) ->
            Restangular.all('folders').customGETLIST("writable")
          ]
]

contexts.controller "ContextsController", [
  "$rootScope"
  "$state"
  "data"
  "mapService"
  "cartService"

  ($root, $state, data, mapService, Cart) ->

    $root.cart = new Cart() # unless $root.cart?

    $root.openCatalog = () ->
      if ($state.current.name.indexOf('catalog') > -1) then $state.go "^" else $state.go ".catalog"

]