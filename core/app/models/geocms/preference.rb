module Geocms
  class Preference < ActiveRecord::Base

    acts_as_tenant(:account)

  end
end