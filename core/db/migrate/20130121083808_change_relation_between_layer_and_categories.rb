class ChangeRelationBetweenLayerAndCategories < ActiveRecord::Migration
  def change
    remove_column :layers, :category_id
    create_table :categories_layers, :id => false do |t|
      t.references :layer, :category
    end
    add_index :categories_layers, [:layer_id, :category_id]
  end
end
