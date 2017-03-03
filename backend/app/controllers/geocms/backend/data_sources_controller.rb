module Geocms
  module Backend
    class DataSourcesController < Geocms::Backend::ApplicationController
      load_and_authorize_resource class: "Geocms::DataSource"

      rescue_from CanCan::AccessDenied do |exception|
        controle_access(exception)
      end

      def index
        @data_sources = DataSource.all.group_by(&:not_internal)
        respond_with(:backend, @data_sources)
      end

      def show
        @data_source = DataSource.find(params[:id])
        respond_with(:backend, @data_source)
      end

      def new
        @data_source = DataSource.new
        respond_with(:backend, @data_source)
      end

      def edit
        @data_source = DataSource.find(params[:id])
      end

      def create
        @data_source = DataSource.new(data_source_params)
        @data_source.save
        respond_with(:import, :backend, @data_source)
      end

      def update
        @data_source = DataSource.find(params[:id])
        @data_source.update_attributes(data_source_params)
        respond_with(:import, :backend, @data_source,data_source_params)
      end

      def destroy
        @data_source = DataSource.find(params[:id])
        @data_source.destroy
        respond_with(:backend, @data_source)
      end

      def import
        @data_source = DataSource.find(params[:id])
        # @layers = @data_source.import
        # gon.categories = Category.for_select.map { |c| { val: c[1], label: c[0] } }
        # gon.rabl "app/views/layers/index.json", :as => :layers, :handler => :rabl
        respond_with(:backend, @data_source)
      end

      private
        def data_source_params
          params.require(:data_source).permit(PermittedAttributes.data_source_attributes)
        end

    end
  end
end
