module Geocms
  class Preference < ActiveRecord::Base

    acts_as_tenant(:account)
    attr_accessible :name, :value

  end
end