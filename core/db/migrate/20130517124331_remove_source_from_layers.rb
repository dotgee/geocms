class RemoveSourceFromLayers < ActiveRecord::Migration
  def change
    remove_column :layers, :source
  end


end
