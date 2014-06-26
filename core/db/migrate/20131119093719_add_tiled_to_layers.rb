class AddTiledToLayers < ActiveRecord::Migration
  def change
    add_column :layers, :tiled, :boolean, default: false
  end
end
