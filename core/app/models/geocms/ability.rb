module Geocms
  class Ability
    include CanCan::Ability

    # Global admin can do everything
    # Instance admin can do everything but create new instances
    # Editors can't destroy items nor administrate users and instances

    def initialize(user)
      user ||= Geocms::User.new # guest user (not logged in)
      if user.has_role? :admin
        can :manage, :all
      elsif user.has_role? :admin
        can :manage, :all
        cannot :create, Account
        cannot :destroy, Account
      elsif user.has_role? :editor
        can :manage, :all
        cannot :destroy, :all
        cannot :create, User
        cannot :manage, Account
      elsif user.new_record?
        can :read, Folder, visibility: true
        can [:new, :read, :share], Context
        can :create, Context, folder: { visibility: true }
        can :update, Context do |context|
          context.new_record? or
          context.folder.nil?
        end
      else
        can :read, Folder, visibility: true
        can [:read, :write], Folder, user: user
        can [:new, :read, :share], Context
        can :create, Context, folder: { user: user }
        can :update, Context, folder: { user: user }
      end

    end
  end
end