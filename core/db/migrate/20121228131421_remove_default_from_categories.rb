class RemoveDefaultFromCategories < ActiveRecord::Migration
  def change
    remove_column :categories, :default
  end
end
