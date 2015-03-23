require_dependency "geocms/application_controller"

module Geocms
  class PagesController < ApplicationController
    after_action :allow_iframe

    def allow_iframe
      response.headers.except! 'X-Frame-Options'
    end

    def index
    end
  end
end
