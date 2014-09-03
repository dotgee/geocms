module Geocms
  class Api::V1::FoldersController < Api::V1::BaseController
    load_and_authorize_resource class: "Geocms::Folder"

    def index
      render json: @folders, each_serializer: FolderShortSerializer
    end

    def show
      @folder = Geocms::Folder.find(params[:id])
      respond_with @folder
    end

    private
    def default_serializer_options
      {
        root: false
      }
    end
  end
end