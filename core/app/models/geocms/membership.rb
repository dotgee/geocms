module Geocms
  class Membership < ActiveRecord::Base

    belongs_to :account
    belongs_to :user

    attr_accessible :account, :user

  end
end