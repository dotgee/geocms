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
          @layer = Geocms::Layer.find(params[:id])
          expires_in 15.minutes, :public => true
          respond_with @layer
        end

        def search
          @layers = Geocms::Layer.joins(:categories).where("geocms_categories.account_id= ?",current_tenant.id).search(params[:q])

          respond_with @layers.to_a.uniq
        end

        def bbox
          layer = Geocms::Layer.find(params[:id])
          @bbox = layer.boundingbox(current_tenant)
          respond_with @bbox
        end

        def queryable
          layer = Geocms::Layer.find(params[:id])

          queryable = false
          if !layer.nil?
            queryable = layer.queryable
            queryable = queryable.nil? ? false : queryable
          end

          render json: {queryable: queryable}
        end 

        def import
          logger.info  "toto"
          Layer.bulk_import(layers_params[:layers])
          
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
