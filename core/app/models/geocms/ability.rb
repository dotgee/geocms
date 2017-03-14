module Geocms
  class Ability
    include CanCan::Ability
    @user = nil
    # Global admin can do everything
    # Instance admin can do everything but create new instances
    # Editors can't destroy items nor administrate users and instances

    def initialize(user, current_tenant)
      @user = user || Geocms::User.new # guest user (not logged in)
      puts "######################################################"
      
      default
      @user.roles.each { |role| send(role.name.to_s) }

      #  User without role (not connected)




=begin
      puts (user.has_role? :admin_data)


      if user.has_role? :user, current_tenant
        puts "User Role: user"
        can [:read, :create, :update, :share], Context
        can :read, Folder,visibility: true
      elsif user.has_any_role? :admin_data,  { name: :admin_data, resource: current_tenant },{ name: :admin_instance, resource: current_tenant },{ name: :admin_appli, resource: current_tenant }
        puts "User Role: admin_data"
        can :manage, Category
        can :manage, Context
        can :manage, DataSource
        can :manage, Layer
        can :manage, Folder
        if user.has_any_role? :admin_instance,  { name: :admin_instance, resource: current_tenant },   { name: :admin_appli, resource: current_tenant }
          puts "User Role: admin_instance"
          can :manage, User
          can :manage, Preference
        end 
        if user.has_role? :admin_appli, current_tenant 
          puts "User Role: admin_appli"
          can :manage, Account
          cannot :create, Account
          cannot :destroy, Account
        end 
      elsif user.has_role? :admin
        puts "User Role: Super admin"
        can :manage, :all
      elsif user.new_record?
        puts "User Role : new user"
        can :read, Folder, visibility: true
        can [:new, :read, :share], Context
        can :create, Context, folder: { visibility: true }
        can :update, Context do |context|
          context.new_record? or
          context.folder.nil?
        end
      else
        puts "User Role : unknow"
        can :read, Folder, visibility: true
        can [:read, :write], Folder, user: user
        can [:new, :read, :share], Context
        can :create, Context, folder: { user: user }
        can :update, Context, folder: { user: user }
      end
      puts "######################################################"
=end
    end
    def default
      can :read, Folder, visibility: true
    end 
    def user
      can :read, Folder, visibility: true
      if !@user.nil?
        can [:read,:write], Folder, user: @user  
        can :create, Context, folder: { user: @user }
        can :update, Context, folder: { user: @user }
      end
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
      can :manage, Preference
      can [:read, :update], Account
    end

    def admin
      can :manage, Preference
      can :manage, Account
      can :manage, User
    end
  end
end