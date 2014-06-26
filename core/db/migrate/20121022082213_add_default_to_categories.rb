class AddDefaultToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :default, :boolean
  end
end
