module Geocms
  class DataSource < ActiveRecord::Base
    acts_as_tenant(:account)

    has_many :layers

    default_scope -> { order("name ASC") }

    validates_presence_of :name, :ogc, :wms
  end
end
