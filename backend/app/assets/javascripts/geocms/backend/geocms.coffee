String.prototype.repeat = ( num ) ->
  new Array( num + 1 ).join( this );

app = angular.module("geocms", [
  "ngTable"
  "restangular"
]).controller("ImportCtrl", ($scope, $location, ngTableParams, Restangular, filterFilter) ->
  Restangular.setBaseUrl(config.prefix_uri+"/api/v1")

  $scope.tableParams = new ngTableParams(
    page: 1 # show first page
    count: 20 # count per page
    # sorting:
    #   name: "asc" # initial sorting
    filter:
      "table.name": "ign"
  ,
    total: 0 # length of data
    getData: ($defer, params) ->
      # console.log $scope.$data
      if $scope.layers?
        $defer.resolve $scope.layers.slice((params.page() - 1) * params.count(), params.page() * params.count())
      else 
        Restangular.one("data_sources", $scope.source_id).customGET("capabilities").then(
          (response) ->
            params.total response.total
            $scope.layers = data.layers
            $defer.resolve data.layers.slice((params.page() - 1) * params.count(), params.page() * params.count())
          , (response) ->
            $scope.error = response.data.message
        )
      return
  )

  Restangular.all("categories").customGETLIST("ordered").then (data) ->
    $scope.categories = data

  $scope.import = () ->
    if $scope.category?
      layers = $scope.extractLayerInformations()
      layers = Restangular.restangularizeElement(null, layers, "layers")
      layers.customPOST({layers: layers}, "import").then (response) ->
        $scope.success = "L'import a réussi."

  $scope.extractLayerInformations = () ->
    layers = _.map filterFilter($scope.layers, {$selected: true}), (layer) ->
      {
        name: layer.table.name
        title: layer.table.title
        data_source_id: $scope.source_id
        category_ids: [$scope.category.id]
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
        # TODO: dimension_values
        # dimension_values: layer.dimension_values
      }

  return
)