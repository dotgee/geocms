#encoding: utf-8
module Geocms
  module Backend
    class ContextsController < Geocms::Backend::ApplicationController
      before_action :load_folder

      def refresh_preview
        @context = Context.find(params[:id])
        @context.send(:generate_preview, request.protocol + request.host + ENV["PREFIX"], true)
        flash[:notice] = I18n.t('context.refreshing')
        redirect_to backend_contexts_path
      end

      def index
        @folders = Folder.all
        @contexts = Context.all
      end

      def show
        @context = Context.find(params[:id])
        respond_with([:backend, @context])
      end

      def new
        @context = Context.new
        respond_with([:backend, @context])
      end

      def create
        @context = Context.new(context_params)
        @context.save
        respond_with([:backend, @context])
      end

      def edit
        @context = Context.find(params[:id])
        respond_with [:backend, @context]
      end

      def update
        @context = Context.find(params[:id])
        @context.update_attributes(context_params)
        respond_with([:edit, :backend, @context])
      end

      def destroy
        @context = Context.find(params[:id])
        @context.destroy
        respond_with [:backend, @context]
      end

      private
        def context_params
          params.require(:context).permit(PermittedAttributes.context_attributes)
        end

        def load_folder
          @folder = Folder.find(params[:folder_id])
        end

    end
  end
end