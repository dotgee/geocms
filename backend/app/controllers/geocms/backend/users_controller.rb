module Geocms
  module Backend
    class UsersController < Geocms::Backend::ApplicationController
      load_and_authorize_resource class: "Geocms::User"

      rescue_from CanCan::AccessDenied do |exception|
        controle_access(exception)
      end

      def index
        @users = current_tenant.users
        @users += Geocms::User.joins(:roles).where("geocms_roles.name='admin'").all
        
        puts "#{@users}"

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
        
        # default role is :user
        if @user.roles.to_a.empty?
          @user.add_role :user
        end

        @user.save
        current_tenant.users << @user
       
        respond_with(:backend, :users)
      end

      def edit
        @user = User.find(params[:id])

        @disable_admin=false

        # admin_instance can't modify a admin or give admin role
        if current_user.has_role? :admin_instance && !(@user.has_role? :admin)
          @disable_admin=true
          if @user.has_role? :admin
             redirect_to action: "index"
          end
        end

      end

      def update
        @user = User.find(params[:id])
        puts current_user.has_role? :admin_instance
        if ( current_user.has_role? :admin_instance ) && !(@user.has_role? :admin)
          @user.update_attributes(user_params)
        elsif current_user.has_role? :admin
          @user.update_attributes(user_params)
        end
      
        respond_with(:edit, :backend, @user)
      end

      def destroy
        @user = User.find(params[:id])

        if current_user.has_role? :admin_instance && !(@user.has_role? :admin)
          current_tenant.users.delete(@user)
          @user.destroy
        elsif current_user.has_role? :admin
          current_tenant.users.delete(@user)
          @user.destroy
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
