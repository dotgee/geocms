module Geocms
  module Backend
    class CategoriesController < Geocms::Backend::ApplicationController
      def index
        @categories = Category.arrange(:order => :position)
        # respond_with([:backend, @categories])
      end

      def show
        @category = Category.find(params[:id])
        @layers = @category.layers.page(params[:page])
        respond_with([:backend, @category])
      end

      def new
        @category = Category.new
        if params[:parent_id]
          @category.parent_id = params[:parent_id]
        end
        respond_with([:backend, @category])
      end

      def edit
        @category = Category.find(params[:id])
      end

      def create
        @category = Category.new(params[:category])
        @category.save
        respond_with([:backend, @category])
      end

      def update
        @category = Category.find(params[:id])
        @category.update_attributes(params[:category])
        respond_with([:backend, @category])
      end

      def destroy
        @category = Category.find(params[:id])
        @category.destroy
        respond_with([:backend, @category])
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
    end
  end
end