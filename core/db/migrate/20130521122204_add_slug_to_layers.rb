class AddSlugToLayers < ActiveRecord::Migration
  def change
    add_column :layers, :slug, :string
    add_index :layers, :slug, unique: true
  end
end
