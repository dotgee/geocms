module Geocms
  module Backend
    class UsersController < Geocms::Backend::ApplicationController
      load_and_authorize_resource

      def index
        @users = current_tenant.users
        respond_with([:backend, @users])
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
        render "_user", locals: { user: @user }, layout: false
      end

      def new
        @user = User.new
        respond_with [:backend, @user]
      end

      def create
        @user = User.new(params[:user])
        @user.save
        current_tenant.users << @user
        current_tenant.save
        respond_with [:backend, :users]
      end

      def edit
        @user = User.find(params[:id])
      end

      def update
        @user = User.find(params[:id])
        @user.update_attributes(params[:user])
        respond_with [:edit, :backend, @user]
      end

      def destroy
        @user = User.find(params[:id])
        current_tenant.users.delete(@user)
        respond_with [:backend, :users]
      end
    end
  end
end