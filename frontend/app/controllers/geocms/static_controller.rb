module Geocms
  class StaticController < ApplicationController
    layout false

    def template
      render template: "geocms/templates/#{params[:template_name]}"
    end
  end
end