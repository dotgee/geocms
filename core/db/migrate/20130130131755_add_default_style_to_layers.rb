class AddDefaultStyleToLayers < ActiveRecord::Migration
  def change
    add_column :layers, :default_style, :string, :default => nil
  end
end
