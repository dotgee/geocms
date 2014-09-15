app = angular.module("geocms", [
  "ngTable"
  "restangular"
]).controller("ImportCtrl", ($scope, $location, ngTableParams, Restangular) ->
  Restangular.setBaseUrl("/api/v1")
  $scope.source_id = $location.absUrl().split("/")[5] # id de la datasource (ugly)

  $scope.tableParams = new ngTableParams(
    page: 1 # show first page
    count: 20 # count per page
    sorting:
      name: "asc" # initial sorting
  ,
    total: 0 # length of data
    getData: ($defer, params) ->
      Restangular.one("data_sources", $scope.source_id).customGET("capabilities").then (data) ->
        params.total data.total
        $defer.resolve data.layers
      return
  )

  $scope.checkedLayers = []

  $scope.markForImport = (layer) ->
    index = $scope.checkedLayers.indexOf(layer)
    if (index > -1)
      $scope.checkedLayers.splice(index, 1)
    else
      $scope.checkedLayers.push (layer)


  $scope.import = () ->
    layer = $scope.extractLayerInformations()
    layers = Restangular.restangularizeElement(null, layers, "layers")
    layers.customPOST({layers: layers}, "import")

  $scope.extractLayerInformations = () ->
    layers = _.map $scope.checkedLayers, (layer) ->
      {
        name: layer.name
        title: layer.title
        data_source_id: $scope.source_id
        bounding_boxes_attributes: _.map(layer.bbox, (box) ->
          bbox = box.table.bbox
          bbox = [bbox[1], bbox[0], bbox[3], bbox[2]] if box.table.srs == "CRS:84"
          {
            crs: box.table.srs
            minx: bbox[0]
            maxx: bbox[1]
            miny: bbox[2]
            maxy: bbox[3]
          }
        )
        # TODO: dimension_values
        # dimension_values: layer.dimension_values
      }

  return
)