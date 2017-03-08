module Geocms
  class Ability
    include CanCan::Ability

    # Global admin can do everything
    # Instance admin can do everything but create new instances
    # Editors can't destroy items nor administrate users and instances

    def initialize(user, current_tenant)
      @user = user || Geocms::User.new # guest user (not logged in)
      puts "######################################################"

      @user.roles.each { |role| send(role.name.to_s) }

      #  User without role 
      if @user.roles.size == 0
        can :read, Folder, visibility: true
        can [:read, :write], Folder, user: user
        can [:new, :read, :share], Context
        can :create, Context, folder: { user: user }
        can :update, Context, folder: { user: user }
      end

      if @user.new_record?
        puts "User Role : new user"
        can :read, Folder, visibility: true
        can [:new, :read, :share], Context
        can :create, Context, folder: { visibility: true }
        can :update, Context do |context|
          context.new_record? or
          context.folder.nil?
        end
      end
    end

    def user
      can [:read, :create, :update, :share], Context
      can :read, Folder,visibility: true
    end

    def admin_data
      can :manage, Category
      can :manage, Context
      can :manage, DataSource
      can :manage, Layer
      can :manage, Folder
    end

    def admin_instance
      can :manage, User
      can :manage, Preference,visibility: true
      can :read, Account, visibility: true
    end

    def admin
      can :manage, Preference
      can :manage, Account
      can :manage, User
    end
  end
end