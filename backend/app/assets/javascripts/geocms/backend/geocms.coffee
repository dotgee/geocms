String.prototype.repeat = ( num ) ->
  new Array( num + 1 ).join( this );

app = angular.module "geocms", ["ngTable", "restangular"]

app.controller "ImportCtrl", 
  [
    "$scope",
    "$location",
    "ngTableParams",
    "Restangular",
    "filterFilter",
    "$filter",
    ($scope, $location, ngTableParams, Restangular, filterFilter, $filter) ->
      Restangular.setBaseUrl(config.prefix_uri+"/api/v1")
      
      $scope.checkboxes = {
        checkAll: false
      }

      $scope.tableParams = new ngTableParams(
        page: 1 # show first page
        count: 10 # count per page
        # sorting:
        #   name: "asc" # initial sorting
      ,
        total: 0 # length of data
        getData: ($defer, params) ->

          filterFullProperties = () ->
            if params.filter()
              $filter('filter')(data.layers, {"$": params.filter().filter})
            else
              data.layers

          getDatasPerPage = (datas) ->
            datas.slice((params.page() - 1) * params.count(), params.page() * params.count())

          reloadPagination = (datas) ->
            params.total(datas.length);

          # console.log $scope.$data
          if $scope.layers?
            orderedDatas = filterFullProperties()
            params.total(orderedDatas.length)
            $defer.resolve $scope.layers = getDatasPerPage(orderedDatas)
          else 
            Restangular.one("data_sources", $scope.source_id).customGET("capabilities").then(
              (response) ->
                params.total response.total
                $defer.resolve $scope.layers = getDatasPerPage(data.layers)
              , (error) ->
                $scope.error = error.data.message
            )
          return
      )

      Restangular.all("categories").customGETLIST("ordered").then (data) ->
        $scope.categories = data

      $scope.$watch "checkboxes.checkAll", (oldVal, newVal) ->
        return if !$scope.layers
        for layer in $scope.layers
          layer.$selected = !newVal
      , true

      $scope.names = (column) ->
        true

      $scope.import = () ->
        if $scope.selectedCategories?
          layers = $scope.extractLayerInformations()
          layers = Restangular.restangularizeElement(null, layers, "layers")
          layers.customPOST({layers: layers}, "import").then (response) ->
            $scope.success = "L'import a réussi."

      $scope.extractLayerInformations = () ->
        layers = _.map filterFilter($scope.layers, {$selected: true}), (layer) ->
          infos = {
            name: layer.table.name
            title: layer.table.title
            description: layer.table.abstract
            data_source_id: $scope.source_id
            category_ids: _.map($scope.selectedCategories, (category) -> category.id)
            bounding_boxes_attributes: _.map(layer.table.bbox, (box) ->
              bbox = box.table.bbox
              bbox = [bbox[1], bbox[0], bbox[3], bbox[2]] if box.table.srs == "EPSG:4326"
              {
                crs: box.table.srs
                minx: bbox[0]
                maxx: bbox[2]
                miny: bbox[1]
                maxy: bbox[3]
              }
            )
          }
          unless angular.equals({},layer.table.dimensions)
            dimensions = { dimensions_attributes: _.map(layer.table.dimensions.time.table.values, (dim) -> value: dim) }
            infos = angular.extend dimensions, infos
          unless angular.equals([],layer.table.metadata_urls)
            infos.metadata_url = layer.table.metadata_urls[0].table.href

          infos

      return
  ]
