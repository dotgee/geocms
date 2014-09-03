module Geocms
  class Ability
    include CanCan::Ability

    def initialize(user, current_tenant)
      user ||= User.new # guest user (not logged in)
      if user.has_role? :admin
        can :manage, :all
      elsif user.has_role? :admin, current_tenant
        can :manage, :all
        cannot :create, Account
        cannot :destroy, Account
      elsif user.has_role? :editor, current_tenant
        can :manage, :all
        cannot :destroy, :all
        cannot :create, User
        cannot :manage, Account
      elsif user.new_record?
        can :read, Context
        can :read, Folder, folder: { visibility: true }
        can :new, Context
        can :share, Context
        can :create, Context, folder: { visibility: true }
      else
        can :read, Context
        can :read, Folder, visibility: true
        can :read, Folder, user: user
        can :new, Context
        can :share, Context
        can :save, Context, folder: { user: user }
      end

      # Global admin can do everything
      # Instance admin can do everything but create new instances
      # Editors can't destroy items nor administrate users and instances
    end
  end
end