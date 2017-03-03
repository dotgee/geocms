module Geocms
  module Backend
    class UsersController < Geocms::Backend::ApplicationController
      load_and_authorize_resource class: "Geocms::User"
      rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_url, :alert => exception.message
      end
      def index
        @users = current_tenant.users

        @isAdmin = current_user.has_role? :admin 
        @isAdmin_instance = current_user.has_role? :admin_instance 

        respond_with(:backend, @users)

      end

      def network
        respond_to do |format|
          format.json { render json: User.network_json }
        end
      end

      def add
        @user = User.where(username: params[:username]).first
        current_tenant.users << @user
        current_tenant.save
       # render "_user", locals: { user: @user }, layout: false
      end

      def new
        @user = User.new
        @user.add_role :user
        respond_with(:backend, @user)
      end

      def create
        @user = User.new(user_params)
        
        if @user.roles.to_a.empty?
          @user.add_role :user
        end

        @user.save

        current_tenant.users << @user
       
        respond_with(:backend, :users)
      end

      def edit
        @user = User.find(params[:id])
        @disable_role = []
        @isAdmin=true
        if !current_user.has_role? :admin
          if @user.has_role? :admin
            redirect_to action: "index"
          end 
          role=Geocms::Role.where("name = ?", :admin).take
          @disable_role << role.id
          @isAdmin=false;
        end

        if !@isAdmin && !(current_user.has_role? :admin_instance)
          if @user.has_role? :admin_instance
            redirect_to action: "index"
          end 
          role=Geocms::Role.where("name = ?", :admin_instance).take
          @disable_role << role.id
        end
      end

      def update
        @user = User.find(params[:id])
        @user.update_attributes(user_params)

        respond_with(:edit, :backend, @user)
      end

      def destroy
        @user = User.find(params[:id])

        if ( !@user.has_role? :admin ) && (can? :destroy, @user )
          if (@user.has_role? :admin_instance )&& (current_user.has_role? :admin)
            current_tenant.users.delete(@user)
            @user.destroy
          else
            current_tenant.users.delete(@user)
            @user.destroy
          end 
        end 
        respond_with(:backend, :users)
      end

      private
        def user_params
          params.require(:user).permit(PermittedAttributes.user_attributes,:role_ids => [])
        end

    end
  end
end
