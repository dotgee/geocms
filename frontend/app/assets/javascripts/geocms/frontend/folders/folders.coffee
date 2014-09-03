folders = angular.module 'geocms.folders', [
  'ui.router'
  'restangular'
]

folders.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider
      .state 'folders',
        url: '/folders'
        views:
          '':
            templateUrl: '/templates/folders/root.html'
          'header':
            templateUrl: '/templates/shared/header.html'
        abstract: true

      # state folders.root : index des folders avec resolve pour recuperer les folders, donc definir API
      .state 'folders.root',
        url: ''
        parent: 'folders'
        views:
          '@':
            templateUrl: '/templates/folders/index.html'
            controller: ['data', '$scope', (data, $scope) ->
              $scope.folders = data
            ]
        resolve:
          data: ['Restangular', (Restangular) ->
            Restangular.all('folders').getList()
          ]

      # state folders.show : affichage d'un folder avec ses contexts
      .state 'folders.show',
        url: '/{slug:[a-zA-Z0-9_]*}'
        parent: 'folders'
        views:
          '@':
            templateUrl: '/templates/folders/show.html'
            controller: ['data', '$scope', (data, $scope) ->
              $scope.folder = data
            ]
        resolve:
          data: ['Restangular', '$stateParams', (Restangular, $stateParams) ->
            Restangular.one('folders', $stateParams.slug).get()
          ]

]
