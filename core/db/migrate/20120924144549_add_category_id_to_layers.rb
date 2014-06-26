class AddCategoryIdToLayers < ActiveRecord::Migration
  def change
    add_column :layers, :category_id, :integer
  end
end
