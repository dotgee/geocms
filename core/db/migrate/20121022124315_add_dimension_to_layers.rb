class AddDimensionToLayers < ActiveRecord::Migration
  def change
    add_column :layers, :dimension, :string
  end
end
