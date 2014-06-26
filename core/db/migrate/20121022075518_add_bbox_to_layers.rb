class AddBboxToLayers < ActiveRecord::Migration
  def change
    add_column :layers, :bbox, :text
    add_column :layers, :crs, :string
  end
end
