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

    def default
      @context = Geocms::Context.where(by_default: true).first
      respond_with @context
    end

    def update
      @context = Geocms::Context.find(params[:id])
      @context.update_attributes(context_params)
      respond_with @context
    end

    private
    def default_serializer_options
      {
        root: false
      }
    end

    def context_params
      params.require(:context).permit(PermittedAttributes.context_attributes)
    end

  end
end