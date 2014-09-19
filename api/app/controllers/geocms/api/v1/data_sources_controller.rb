module Geocms
  class Api::V1::DataSourcesController < Api::V1::BaseController

    def capabilities
      data_source = DataSource.find(params[:id])
      context = ReadDataSource.call({url: data_source.wms})
      if context.state == "failed"
        render json: {state: "failed", message: "L'import n'a pas pu aboutir, vérifiez que la source de données fonctionne correctement."}, status: :unprocessable_entity
      else
        render json: {layers: context.layers.map(&:olayer), total: context.layers.size}
      end
    end
  end
end