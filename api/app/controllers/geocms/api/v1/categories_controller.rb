module Geocms
  class Api::V1::CategoriesController < Api::V1::BaseController

    def index
      @categories = Category.roots.ordered
      render json: @categories, each_serializer: CategoryShortSerializer
    end

    def show
      @category = Category.includes(layers: [:data_source]).find params[:id]
      respond_with @category
    end

    def ordered
      @categories = Category.arrange_as_array(order: :name)
      respond_with @categories, each_serializer: CategoryShortSerializer
    end

    private
    def default_serializer_options
      {
        root: false
      }
    end

  end
end
