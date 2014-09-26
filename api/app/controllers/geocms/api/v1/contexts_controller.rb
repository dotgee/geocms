module Geocms
  class Api::V1::ContextsController < Api::V1::BaseController
    respond_to :xml, only: :wmc
    serialization_scope :current_user
    
    def index
      @contexts = Geocms::Context.all
      respond_with @contexts
    end

    def show
      @context = Geocms::Context.where(uuid: params[:id]).first
      respond_with @context
    end

    def default
      @context = Geocms::Context.where(by_default: true).first
      respond_with @context
    end

    def update
      @context = Geocms::Context.find(params[:id])
      if can? :update, @context
        if @context.update_attributes(context_params)
          render json: @context
        else
          render json: @context.errors.to_hash
        end
      else
        render json: "Vous n'avez pas les droits pour sauvegarder cette carte.", status: :forbidden
      end
    end

    def create
      if can? :create, Geocms::Context
        @context = Geocms::Context.new(context_params)
        if @context.save
          render json: @context
        else
          render json: @context.errors.full_messages.join(", "), status: :malformed_request
        end
      else
        render json: "Vous n'avez pas les droits pour créer cette carte.", status: :forbidden
      end
    end

    def wmc
      @context = Geocms::Context.find(params[:id])
      render(template: "geocms/api/v1/contexts/wmc", formats: [:xml], handlers: :builder, layout: false)
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