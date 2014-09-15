module Geocms
  class Api::V1::DataSourcesController < Api::V1::BaseController

    def capabilities
      data_source = DataSource.find(params[:id])
      layers = ReadDataSource.call({url: data_source.wms}).layers
      render json: {layers: layers.map(&:olayer), total: layers.size}
    end
  end
end