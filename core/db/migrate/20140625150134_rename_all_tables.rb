class RenameAllTables < ActiveRecord::Migration
  def change
    rename_table :accounts, :geocms_accounts
    rename_table :bounding_boxes, :geocms_bounding_boxes
    rename_table :categories, :geocms_categories
    rename_table :categories_layers, :geocms_categories_layers
    rename_table :contexts, :geocms_contexts
    rename_table :contexts_layers, :geocms_contexts_layers
    rename_table :data_sources, :geocms_data_sources
    rename_table :dimensions, :geocms_dimensions
    rename_table :layers, :geocms_layers
    rename_table :memberships, :geocms_memberships
    rename_table :preferences, :geocms_preferences
    rename_table :roles, :geocms_roles
    drop_table :taggings
    drop_table :tags
    rename_table :users, :geocms_users
    rename_table :users_roles, :geocms_users_roles
  end
end
