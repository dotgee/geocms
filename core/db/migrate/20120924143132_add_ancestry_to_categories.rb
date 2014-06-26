class AddAncestryToCategories < ActiveRecord::Migration
  def up
    add_column :categories, :ancestry, :string
    add_index :categories, :ancestry
    add_column :categories, :names_depth_cache, :string
  end

  def down
  end
end
