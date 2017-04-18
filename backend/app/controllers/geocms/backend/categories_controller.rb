module Geocms
  module Backend
    class CategoriesController < Geocms::Backend::ApplicationController
      load_and_authorize_resource class: "Geocms::Category"
      load_and_authorize_resource class: "Geocms::DataSource"

      rescue_from CanCan::AccessDenied do |exception|
        controle_access(exception)
      end

      def index
        @categories = Category.arrange(:order => :position)
        @tabSynchro = []
        # respond_with(:backend, @categories)
        
        Category.all.each do |cat|
          datasource = DataSource.where(geocms_category_id: cat.id).first
          synchro = false
          if !datasource.nil? 
            synchro = datasource.synchro
          end
          @tabSynchro.insert(cat.id, synchro)
        end
      end

      def show
        @category = Category.find(params[:id])
        datasource = DataSource.where(geocms_category_id: @category.id).first
        @synchro = false
        if !datasource.nil? 
          @synchro = datasource.synchro
        end
        @layers = @category.layers.page(params[:page])

        respond_with(:backend, @categorys)
      end

      def new
        @category = Category.new
        if params[:parent_id]
          @category.parent_id = params[:parent_id]
        end
        respond_with(:backend, @category)
      end

      def edit
        @category = Category.find(params[:id])
      end

      def create
        @category = Category.new(category_params)
        @category.save
        respond_with(:backend, @category)
      end

      def update
        @category = Category.find(params[:id])
        @category.update_attributes(category_params)
        respond_with(:backend, @category)
      end

      def destroy
        @category = Category.find(params[:id])
        @dataSource = DataSource.where(geocms_category_id: @category.id).first
       
        if !@dataSource.nil?
          @dataSource.geocms_category_id = nil;
          @dataSource.synchro = false;
          @dataSource.save;
        end

        @category.destroy
        respond_with(:backend, @category)
      end

      def move
        @category = Category.find(params[:id])
        if(params[:direction] == "up")
          @category.move_higher
        else
          @category.move_lower
        end
        redirect_to [:backend, :categories]
      end

      private
        def category_params
          params.require(:category).permit(PermittedAttributes.category_attributes)
        end
    end
  end
end
