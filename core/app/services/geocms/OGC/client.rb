module Geocms
  module OGC
    class Client

      attr_accessor :wms_service, :feature_name, :width, :height, :bbox, :current_x, :current_y, :request_url, :response

      def initialize(wms_url:, feature_name:, width: nil, height: nil, bbox: nil, current_x: nil, current_y: nil)
        @wms_service = wms_url
        @feature_name = feature_name
        @width = width
        @height = height
        @bbox = bbox
        @current_x = current_x
        @current_y = current_y
      end

      def get_feature_info
        build_get_feature_info_request
        get_feature_info_response
        @response
      end

      private

      def build_get_feature_info_request
        @request_url = "#{@wms_service}?SERVICE=WMS&VERSION=1.1.1"\
          "&REQUEST=GetFeatureInfo"\
          "&QUERY_LAYERS=#{@feature_name}"\
          "&LAYERS=#{@feature_name}"\
          "&BBOX=#{@bbox}"\
          "&X=#{@current_x}&Y=#{@current_y}"\
          "&HEIGHT=#{@height}&WIDTH=#{@width}"\
          "&INFO_FORMAT=application/json&"\
          "SRS=EPSG:4326&FEATURE_COUNT=500"
      end

      def get_feature_info_response
        Curl::Easy.new(@request_url) do |curl|
          curl.on_success do |response|
            @response = JSON.parse(response.body_str)
          end
          curl.on_failure do |response, error|
            @response = {status: "failed"}
          end
        end.perform
      end
    end
  end
end