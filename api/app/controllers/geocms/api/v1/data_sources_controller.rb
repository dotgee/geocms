require File.join(Rails.root, "../geocms/core/app/services/geocms/OGC/client.rb")
module Geocms
  class Api::V1::DataSourcesController < Api::V1::BaseController
    

    def capabilities
      data_source = DataSource.find(params[:id])

      context = ReadDataSource.call({url: data_source.wms})
      if context.state == "failed"
       # render json: {state: "failed", message: data_source.wms}, status: :unprocessable_entity
       render json: {state: "failed", message: "L'import n'a pas pu aboutir, vérifiez que la source de données fonctionne correctement."}, status: :unprocessable_entity
      else
        render json: {layers: context.layers.map(&:olayer), total: context.layers.size}
      end
    end

    def get_feature_infos

      client = Geocms::OGC::Client.new(feature_infos_params.symbolize_keys)
      render json: client.get_feature_info
    end

    def get_log_file  
      if params[:filename] && File.exist?(Rails.root.to_s+"/log/update/"+params[:filename] +".log")
         file_path = File.join(Rails.root, "log", "update")
         send_file(  File.join(file_path,  params[:filename]+".log"))
      else 
        respond_with "no file : "+ Rails.root.to_s+"/log/update/"+params[:filename] +".log"
      end
#       respond_with "no file : "+ Rails.root.to_s+"log/update/"+params[:filename] +".log"
    end

    private

    def feature_infos_params
      params.permit(:wms_url, :feature_name, :width, :height, :bbox, :current_x, :current_y, :time)
    end
  end
end
