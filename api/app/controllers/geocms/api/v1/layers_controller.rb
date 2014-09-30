module Geocms
  module Api
    module V1
      class LayersController < Geocms::Api::V1::BaseController

        def index
          if params[:ids]
            @layers = current_tenant.layers.where(:id => params[:ids].split(","))
          else
            @layers = current_tenant.layers
          end
          @layers = @layers.page(params[:page]).per(params[:per_page])
          expires_in 15.minutes, :public => true
          respond_with @layers
        end

        def show
          @layer = current_tenant.layers.find(params[:id])
          expires_in 15.minutes, :public => true
          respond_with @layer
        end

        def search
          @layers = current_tenant.layers.search(params[:q])
          respond_with @layers
        end

        def bbox
          layer = current_tenant.layers.find(params[:id])
          @bbox = layer.boundingbox(current_tenant)
          respond_with @bbox
        end

        def import
          layers_params[:layers].each do |layer_param|
            Layer.create!(layer_param)
          end
          render json: {status: "ok"}
        end

        private
          def layers_params
            params.permit!
          end
      end

    end
  end
end