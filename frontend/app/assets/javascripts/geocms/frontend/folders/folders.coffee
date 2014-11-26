folders = angular.module 'geocms.folders', [
  'ui.router'
  'restangular'
]

folders.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider
      .state 'folders',
        url: config.prefix_uri+'/projects'
        views:
          '':
            templateUrl: config.prefix_uri+'/templates/folders/root.html'
          'header':
            templateUrl: config.prefix_uri+'/templates/shared/header.html'
        abstract: true

      # state folders.root : index des folders avec resolve pour recuperer les folders, donc definir API
      .state 'folders.root',
        url: ''
        parent: 'folders'
        views:
          '@':
            templateUrl: config.prefix_uri+'/templates/folders/index.html'
            controller: ['data', '$scope', (data, $scope) ->
              $scope.folders = data
            ]
        resolve:
          data: ['Restangular', (Restangular) ->
            Restangular.all('folders').getList()
          ]

      # state folders.show : affichage d'un folder avec ses contexts
      .state 'folders.show',
        url: '/{slug}'
        parent: 'folders'
        views:
          '@':
            templateUrl: config.prefix_uri+'/templates/folders/show.html'
            controller: ['data', '$scope', (data, $scope) ->
              $scope.folder = data
            ]
        resolve:
          data: ['Restangular', '$stateParams', (Restangular, $stateParams) ->
            Restangular.one('folders', $stateParams.slug).get()
          ]

]
