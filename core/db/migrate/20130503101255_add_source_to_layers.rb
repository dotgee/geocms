class AddSourceToLayers < ActiveRecord::Migration
  def change
    add_column :layers, :source, :string
  end
end
