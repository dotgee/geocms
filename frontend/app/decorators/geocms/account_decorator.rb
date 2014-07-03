module Geocms
  class AccountDecorator < Draper::Decorator
    delegate_all

    def logo_image_tag
      url = (object && object.logo?) ? object.logo : "geocms/dotgeocms.png"
      h.image_tag url
    end

  end
end