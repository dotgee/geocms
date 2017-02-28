module Geocms
  class Api::V1::ContextsController < Api::V1::BaseController
    respond_to :xml, only: :wmc
    serialization_scope :current_scope

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
          Geocms::ContextPreviewWorker.perform_async(@context.id, current_tenant.id)
          render json: @context
        else
          render json: @context.errors.to_hash
        end
      else
        render json: "Vous n'avez pas les droits pour sauvegarder cette carte.", status: :forbidden
      end
    end

    def create
      puts "Create context ?"
      if can? :create, Geocms::Context
        puts "oui, context created"
        @context = Geocms::Context.new(context_params)
        if @context.save
          Geocms::ContextPreviewWorker.perform_async(@context.id, current_tenant.id)
          render json: @context
        else
          render json: {message: @context.errors.full_messages.join(" ")}, status: 400
        end
      else
        puts "non, context not created"
        render json: "Vous n'avez pas les droits pour créer cette carte.", status: :forbidden
      end
    end

    def wmc
      @context = Geocms::Context.find(params[:id])
      @crs = params[:crs] ? params[:crs] : current_tenant.crs.value
      @bounding_box = Geocms::ProjectionConverter.new(@crs).bbox
      @point_max = (@context.maxx.nil? || @context.maxy.nil?) ? [@bounding_box[2], @bounding_box[3]] : Geocms::ProjectionConverter.new(@crs, [@context.maxx, @context.maxy]).project
      @point_min = (@context.minx.nil? || @context.miny.nil?) ? [@bounding_box[2], @bounding_box[3]] : Geocms::ProjectionConverter.new(@crs, [@context.minx, @context.miny]).project
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

    def current_scope
      {
        user: current_user,
        account: current_tenant
      }
    end

  end
end