class AddMaxZoomToLayers < ActiveRecord::Migration
  def change
    add_column :geocms_layers, :max_zoom, :integer, default: 19
  end
end
