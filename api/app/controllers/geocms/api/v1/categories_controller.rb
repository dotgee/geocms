module Geocms
  class Api::V1::CategoriesController < Api::V1::BaseController

    def index
      respond_with Category.arrange_serializable(order: :position)
    end

  end
end
