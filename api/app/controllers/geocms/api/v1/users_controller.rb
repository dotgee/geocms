require 'json'
module Geocms
  class  Api::V1::UsersController < Api::V1::BaseController

    respond_to :json
    def index
      respond_with "test"
    end 
    def show
      if !current_user.nil?
        render json: {:create_context=> (can? :creat, Geocms::Context), :user_id => current_user.id}
      else 
        render json: {:create_context=> false, :user_id => -1}
      end
    end 
  end
end

