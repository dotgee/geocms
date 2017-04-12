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
        url: config.prefix_uri+"/maps"
        views:
          "":
            templateUrl: config.prefix_uri+"/templates/contexts/root.html"
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
            templateUrl: config.prefix_uri+"/templates/contexts/sidebar.html"
            controller: "ContextsController"
          "map@contexts":
            templateUrl: config.prefix_uri+"/templates/contexts/map.html"
            controller: ["context", "$state","Restangular","$rootScope", (context, $state,Restangular,$root) ->

              if context != null && context != undefined && context != "null"
                $state.transitionTo('contexts.show', {uuid: context.uuid})
              else
                Restangular.one('users').customGET("index").then( 
                  (user) ->
                    $root.connexion = {
                      message: "connexion"
                    }
                    if user? && user.data? && user.data.user_id? && user.data.user_id != -1
                      $root.cart.user = user.data;  
                      $root.connexion.message = "déconexion";
                    else
                      $root.cart.user = null;

                    if user.data.create_context
                      $state.transitionTo('contexts.new',{editable:true})
                    else 
                      $state.transitionTo('contexts.new',{editable:false})
                )
            ]
        resolve:
          context: ["Restangular", (Restangular) ->
            Restangular.all('contexts').customGET("default")
          ]

      .state 'contexts.new',
        url: '/new/:editable'
        parent: 'contexts.root'
        views:
          "map@contexts":
            templateUrl: config.prefix_uri+"/templates/contexts/map.html"
            controller: ["mapService", "folders", "$rootScope", "$scope", "Restangular", '$location','$stateParams', (mapService, folders, $root, $scope, Restangular, $location,$stateParams) ->
              
              # create context
              context = { center_lat: config.latitude, center_lng: config.longitude, zoom: config.zoom }
              mapService.createMap("map", context.center_lat, context.center_lng, context.zoom)
              $root.cart.context = Restangular.restangularizeElement(null, context, "contexts")
              mapService.addBaseLayer()
              console.log("ProspectsCtrl StateParams: ", $stateParams.editable)
              
              # default config
              $root.cart.folders = folders
              $root.cart.context.editable = true
              $root.cart.state = "new"
              $scope.mapService = mapService
              
              # check if user can create a context
              if $stateParams.editable? && $stateParams.editable != ""
                $root.cart.context.editable = $stateParams.editable
              else if $root.cart.user?
                $root.cart.context.editable = $root.cart.user.create_context
              else 
                Restangular.one('users').customGET("index").then( 
                  (user) ->
                      if !user.data.create_context
                        window.location.href = '/login'
                      
                )
              
              $location.hash('project')
            ]
          "plugins@contexts.new":
            templateUrl: config.prefix_uri+"/templates/contexts/plugins.html"

      .state 'contexts.show',
        url: '/{uuid}'
        parent: 'contexts.root'
        views:
          "sidebar@contexts":
            templateUrl: config.prefix_uri+"/templates/contexts/sidebar.html"
            controller: "ContextsController"
          "map@contexts":
            templateUrl: config.prefix_uri+"/templates/contexts/map.html"
            controller: ["mapService", "context", "folders", "$rootScope", "$scope", '$location','Restangular', (mapService, context, folders, $root, $scope, $location, Restangular) ->
              mapService.createMap("map", context.center_lat, context.center_lng, context.zoom)
              mapService.addBaseLayer()
              $root.cart.context = context
              $root.cart.addSeveral()
              $location.hash('project')

              Restangular.one('users').customGET("index").then( 
                (user) ->
                  $root.connexion = {
                    message: "connexion"
                  }
                  if user? && user.data? && user.data.user_id? && user.data.user_id != -1
                    $root.cart.user = user.data;  
                    $root.connexion.message = "déconexion";
                  else
                    $root.cart.user = null;
                

                    
              )
            ]
          "plugins@contexts.show":
            templateUrl: config.prefix_uri+"/templates/contexts/plugins.html"
        resolve:
          context: ["Restangular", "$stateParams", (Restangular, $stateParams) ->
            Restangular.one('contexts', $stateParams.uuid).get()
          ]

      .state 'contexts.edit',
        url: '/{uuid}/edit'
        parent: 'contexts.root'
        views:
          "sidebar@contexts":
            templateUrl: config.prefix_uri+"/templates/contexts/sidebar.html"
            controller: "ContextsController"
          "map@contexts":
            templateUrl: config.prefix_uri+"/templates/contexts/map.html"
            controller: ["mapService", "context", "folders", "$rootScope", "$scope", '$location', '$state', (mapService, context, folders, $root, $scope, $location, $state) ->
              $state.transitionTo('contexts.show', {uuid: context.uuid}) unless context.editable
              mapService.createMap("map", context.center_lat, context.center_lng, context.zoom)
              mapService.addBaseLayer()
              $root.cart.context = context
              $root.cart.addSeveral()
              $root.cart.context.selected_folder=0

              for value, index in folders
                if value.id == context.folder_id
                  $root.cart.context.selected_folder=value

              $root.cart.folders = folders
              $scope.mapService = mapService
              $location.hash('project')
            ]
          "plugins@contexts.edit":
            templateUrl: config.prefix_uri+"/templates/contexts/plugins.html"
        resolve:
          context: ["Restangular", "$stateParams", (Restangular, $stateParams) ->
            Restangular.one('contexts', $stateParams.uuid).get()
          ]

      .state 'contexts.show.share',
        url: '/share?plugins'
        parent: 'contexts.show'
        views:
          "sidebar@contexts":
            templateUrl: ""
            controller: "ContextsController"
          "map@contexts":
            templateUrl: config.prefix_uri+"/templates/contexts/map.html"
            controller: ["mapService", "context", "folders", "$rootScope", "$stateParams", "$scope", (mapService, context, folders, $root, $stateParams, $scope) ->
              mapService.createMap("map", context.center_lat, context.center_lng, context.zoom, $stateParams["plugins"])
              mapService.addBaseLayer()
              $root.cart.context = context
              $root.cart.addSeveral()
              $scope.mapService = mapService
            ]
          "plugins@contexts.show":
            templateUrl: ""
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

    $scope.state = $state.current.name

    watchers = '[cart.context.name, cart.context.description, cart.context.folder_id, cart.context.center_lng, cart.context.center_lat, cart.context.zoom]'
    $root.$watchCollection watchers, (newValues, oldValues) ->
      $root.cart.state = "unsaved" unless angular.equals(newValues, oldValues)
    , true

    $scope.openCatalog = (with_search) ->
      if $scope.catalogOpened()  
        $state.go "^" 
      else
        $state.go ".catalog"

    $scope.catalogOpened = () ->
      $state.current.name.indexOf('catalog') > -1

    $scope.treeOptions = {
      dropped: (event) ->
        $root.cart.recalculateLayerZIndex()
    }
    $scope.connexion = () -> 
      if( $root.cart.user? )
        window.location.href = '/logout'
      else
        window.location.href = '/login'


    $scope.setCurrenLayer = (layer) ->
       $root.cart.currentLayer = layer
       $root.cart.currentLayer.options = {
          opacity : layer.opacity/100.0;
       } 
       console.log( $root.cart.currentLayer);

    $scope.mapOptions = optionService
    $scope.mapService = mapService
    $scope.showOption = false
    
   
   

    console.log("USER : ", $root.cart.user);
]