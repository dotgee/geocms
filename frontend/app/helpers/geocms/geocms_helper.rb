module Geocms
  module GeocmsHelper
    # ENV["PREFIX"]
    def share_link(iframe = false)
      (iframe ? "<iframe src='" : "") + "#{request.protocol}#{request.host_with_port}"
    end

    def geovisu_link
      "#{request.protocol}#{request.host_with_port}/geovisu/?wmc=#{share_link}/"
    end
  end
end
