module Geocms
  module Backend
    class UsersController < Geocms::Backend::ApplicationController
      load_and_authorize_resource class: "Geocms::User"
      rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_url, :alert => exception.message
      end
      def index
        @users = current_tenant.users
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
        respond_with(:backend, @user)
      end

      def create
        puts "create"
        @user = User.new(user_params)
        puts "save"
        @user.save
        puts "add user to current_tenant"
        current_tenant.users.create( user_params)
        puts "save current_tenant"
        current_tenant.save
        puts "end create"
        respond_with(:backend, :users)
      end

      def edit
        @user = User.find(params[:id])
      end

      def update
        @user = User.find(params[:id])
        @user.update_attributes(user_params)
        puts "Param user : "
        puts user_params
        puts "--------------"
        respond_with(:edit, :backend, @user)
      end

      def destroy
        @user = User.find(params[:id])
        current_tenant.users.delete(@user)
        respond_with(:backend, :users)
      end

      private
        def user_params
          params.require(:user).permit(PermittedAttributes.user_attributes,:role_ids => [])
        end

    end
  end
end
