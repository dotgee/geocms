class AddVisibilityToContextsLayers < ActiveRecord::Migration
  def change
    add_column :contexts_layers, :visibility, :boolean, :default => true
  end
end
