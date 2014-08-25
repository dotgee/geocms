module Geocms
  module Backend
    class AccountsController < Geocms::Backend::ApplicationController
      load_and_authorize_resource class: "Geocms::Account"

      def index
        @accounts = Account.all
      end

      def new
        @account = Account.new
        user = @account.users.build
        respond_with [:backend, @account]
      end

      def create
        @account = Account.new(params[:account])
        @account.save
        respond_with [:backend, :accounts]
      end

      def destroy
        @account = Account.find(params[:id])
        @account.destroy
        respond_with [:backend, :accounts]
      end
    end
  end
end