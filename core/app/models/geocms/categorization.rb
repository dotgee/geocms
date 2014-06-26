module Geocms
  class Categorization < ActiveRecord::Base
    belongs_to :category
    belongs_to :layer
  end
end
