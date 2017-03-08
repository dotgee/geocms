module Geocms
  module Backend
    class FoldersController < Geocms::Backend::ApplicationController
      load_and_authorize_resource class: "Geocms::Folder"

      rescue_from CanCan::AccessDenied do |exception|
        controle_access(exception)
      end

      before_filter :set_folder, only: [:edit, :show, :update, :destroy]

      def index
        @folders = Folder.ordered
        tab_roles = current_user.roles
       
        tab_user_role = []
        tab_roles.each do |r|
          tab_user_role << r.name
        end

        puts "tab :  #{tab_user_role}, #{tab_user_role.include? "admin_data"} &&  (( #{tab_user_role.include? "admin_instance"}) || (#{ tab_user_role.include? "admin"} ))"
        @isAdmin = ( tab_user_role.include? "admin_data" )&&  (( tab_user_role.include? "admin_instance") || (tab_user_role.include? "admin" ))
        puts "is admin ? #{@isAdmin}, ? #{(( tab_user_role.include? "admin_instance") || (tab_user_role.include? "admin" ))}"
      end

      def new
        @folder = Folder.new
      end

      def create
        @folder = current_user.folders.new(folder_params)
        @folder.save ? (redirect_to [:backend, :folders]) : (render 'new')
      end

      def edit
      end

      def update
        @folder.update_attributes(folder_params) ? (redirect_to [:backend, :folders]) : (render 'edit')
      end

      def show
        @contexts = @folder.contexts
      end

      def destroy
        @folder.destroy
        redirect_to [:backend, :folders]
      end

      private
        def folder_params
          params.require(:folder).permit(PermittedAttributes.folder_attributes)
        end

        def set_folder
          @folder = Folder.find(params[:id])
        end

    end
  end
end