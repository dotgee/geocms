module Geocms
  module Backend
    class LayersController < Geocms::Backend::ApplicationController
      #before_filter :require_category, :only => [:destroy]
      load_and_authorize_resource class: "Geocms::Layer"

      rescue_from CanCan::AccessDenied do |exception|
        controle_access(exception)
      end

      def index
        @layers = current_tenant.layers.page(params[:page]).per(params[:per_page])
        respond_with(:backend, @layers)
      end

      def show
        @layer = @category.layers.find(params[:id])

        respond_with(:backend, @category, @layer)
      end

      def getfeatures
        layer = Layer.find(params[:id])
        @features = OGC::DescribeFeatureType.new(layer.data_source_wms, layer.name).properties
        respond_to do |format|
          format.json { render json: @features }
        end
      end

      def new
        @layer = Layer.new
        respond_with(:backend, @layer)
      end

      def edit
        @layer = Layer.find(params[:id])
        @categories = Category.for_select
        respond_with(:backend, @category, @layer)
      end

      def create
        dimension_values = params.delete(:dimension_values)
        bbox = params.delete(:bbox)
        @layer = Layer.new(layer_params.reject{ |p| p == "category_id" })
        @layer.crs = params.delete(:srs).first.to_s if params[:srs].present?
        if @layer.save
          if dimension_values && dimension_values.any?
            Dimension.create_dimension_values(@layer, dimension_values)
          end
          if bbox && bbox.any?
            BoundingBox.create_bounding_boxes(@layer, bbox)
          end
          @layer.do_thumbnail
        end

        respond_with(@layer) do |format|
          format.json if request.xhr?
          format.html { redirect_to [:edit, :backend, @layer] }
        end
      end

      def update
        @layer = Layer.find(params[:id])
        @layer.update_attributes(layer_params)
        respond_with(:edit, :backend, @layer)
      end

      def destroy
        if params[:category_id].present?
          @category = Category.find(params[:category_id])
          @layer = @category.layers.find(params[:id])
          @layer.categories.delete(@category)
          # Destroy the relationship between category and layer, if layer doesn't have any categories left, destroy the layer
          if @layer.categories.empty?
            @layer.destroy
          else
            @layer.save
          end
          respond_with(:backend, @category)
        else
          @layer = Layer.find(params[:id])
          @layer.destroy
          redirect_to :backend_layers
        end
      end

      private
        def require_category
          if params[:category_id].present?
            @category = Category.find(params[:category_id])
          else
            @category = Category.find(layer_params[:category_id])
          end
        end

        def layer_params
          params.require(:layer).permit(PermittedAttributes.layer_attributes)
        end
    end
  end
end
