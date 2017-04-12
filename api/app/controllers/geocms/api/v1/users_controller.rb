require 'json'
module Geocms
  class  Api::V1::UsersController < Api::V1::BaseController

    respond_to :json
    def index
      respond_with "test"
    end 
    def show
      if !current_user.nil?
        render json: { :data => {:create_context=> (can? :create, Geocms::Context), :user_id => current_user.id, :user_name => current_user.username} }
      else 
        render json: { :data => {:create_context=> false, :user_id => -1} }
      end
    end 
  end
end

