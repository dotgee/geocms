module Geocms
  class Api::V1::ContextsController < Api::V1::BaseController

    def index
      @contexts = Geocms::Context.all
      respond_with @contexts
    end

    def show
      @context = Geocms::Context.find(params[:id])
      respond_with @context
    end


    private
    def default_serializer_options
      {
        root: false
      }
    end

  end
end