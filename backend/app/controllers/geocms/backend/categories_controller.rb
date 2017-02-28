module Geocms
  module Backend
    class CategoriesController < Geocms::Backend::ApplicationController
      load_and_authorize_resource class: "Geocms::Category"
      rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_url, :alert => exception.message
      end
      def index
        @categories = Category.arrange(:order => :position)
        # respond_with(:backend, @categories)
      end

      def show
        @category = Category.find(params[:id])
        @layers = @category.layers.page(params[:page])
        respond_with(:backend, @category)
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
