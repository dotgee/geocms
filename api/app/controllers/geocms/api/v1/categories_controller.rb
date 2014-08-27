module Geocms
  class Api::V1::CategoriesController < Api::V1::BaseController

    def index
      @categories = Category.roots
      render json: @categories, each_serializer: CategoryShortSerializer
    end

    def show
      @category = Category.includes(layers: [:data_source]).find params[:id]
      respond_with @category
    end

    private
    def default_serializer_options
      {
        root: false
      }
    end

  end
end
