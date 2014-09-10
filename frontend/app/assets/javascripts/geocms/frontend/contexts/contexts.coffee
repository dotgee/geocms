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
        resolve:
          folders: ["Restangular", (Restangular) ->
            Restangular.all('folders').customGETLIST("writable")
          ]

      .state 'contexts.root',
        url: ""
        parent: "contexts"
        views:
          "sidebar@contexts":
            templateUrl: "/templates/contexts/sidebar.html"
            controller: "ContextsController"
          "map@contexts":
            templateUrl: "/templates/contexts/map.html"
            controller: ["mapService", "data", "$rootScope", "$state", "$scope", "Restangular", (mapService, data, $root, $state, $scope, Restangular) ->
              if data != null && data != undefined && data != "null"
                $state.transitionTo('contexts.show', {slug: data.slug})
              else
                context = { center_lat: 48.331638, center_lng: -4.34526, zoom: 6 }
                mapService.createMap("map", context.center_lat, context.center_lng, context.zoom)
                $root.cart.context = Restangular.restangularizeElement(null, context, "contexts")
                mapService.addBaseLayer()
              $scope.mapService = mapService
            ]
        resolve:
          data: ["Restangular", (Restangular) ->
            Restangular.all('contexts').customGET("default")
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
            controller: ["mapService", "data", "folders", "$rootScope", "$scope", (mapService, data, folders, $root, $scope) ->
              mapService.createMap("map", data.center_lat, data.center_lng, data.zoom)
              mapService.addBaseLayer()
              $root.cart.context = data
              $root.cart.addSeveral()
              $root.cart.folders = folders
              $scope.mapService = mapService
            ]
        resolve:
          data: ["Restangular", "$stateParams", (Restangular, $stateParams) ->
            Restangular.one('contexts', $stateParams.slug).get()
          ]

      .state 'contexts.show.share',
        url: '/share'
        parent: 'contexts.show'
        views:
          "header@":
            templateUrl: ""
          "sidebar@contexts":
            templateUrl: ""
            controller: "ContextsController"
]

contexts.controller "ContextsController", [
  "$scope"
  "$rootScope"
  "$state"
  "mapService"
  "cartService"
  "mapOptionService"

  ($scope, $root, $state, mapService, Cart, optionService) ->

    $root.cart = new Cart()

    watchers = '[cart.context.name, cart.context.description, cart.context.folder_id, cart.context.center_lng, cart.context.center_lat, cart.context.zoom]'
    $root.$watchCollection watchers, () ->
      $root.cart.state = "unsaved"
    , true

    $scope.openCatalog = () ->
      if $scope.catalogOpened() then $state.go "^" else $state.go ".catalog"

    $scope.catalogOpened = () ->
      $state.current.name.indexOf('catalog') > -1

    $scope.treeOptions = {
      dropped: (event) ->
        console.log event.dest
    }

    $scope.mapOptions = optionService
    $scope.mapService = mapService
]