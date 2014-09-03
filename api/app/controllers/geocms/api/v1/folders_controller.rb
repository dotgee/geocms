module Geocms
  class Api::V1::FoldersController < Api::V1::BaseController

    def index
      @folders = Geocms::Folder.all
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