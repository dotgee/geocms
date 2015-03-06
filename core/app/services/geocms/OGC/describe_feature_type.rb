module Geocms
  module OGC
    class DescribeFeatureType

      def initialize(url, layer_name)
        @url = url
        @layer_name = layer_name
      end

      def properties
        data = Net::HTTP.get_response(URI.parse(@url+"?SERVICE=WFS&VERSION=2.0.0&REQUEST=DescribeFeatureType&typeName=#{@layer_name}&QUERY_LAYERS=#{@layer_name}&outputFormat=application/json")).body
        p = []
        p = (JSON.parse(data)["featureTypes"].map {|v| v["properties"] }.flatten.map { |f| [f["name"]] } rescue [] )if data
        p
      end

    end
  end
end

