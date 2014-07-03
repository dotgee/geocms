module Geocms
  class Api::V1::ContextsController < Api::V1::BaseController

    def index
      @contexts = Geocms::Context.all.to_a
      respond_with @contexts
    end

    def show
      @context = Geocms::Context.find(params[:id])
      respond_with @context
    end

  end
end