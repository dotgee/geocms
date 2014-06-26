class AddOrderAndOpacityToContextLayers < ActiveRecord::Migration
  def change
    add_column :contexts_layers, :position, :integer
    add_column :contexts_layers, :opacity, :integer
  end
end
