module Geocms
  class Role < ActiveRecord::Base
    has_and_belongs_to_many :users, :join_table => :geocms_users_roles
    belongs_to :resource, :polymorphic => true

    scopify
  end
end