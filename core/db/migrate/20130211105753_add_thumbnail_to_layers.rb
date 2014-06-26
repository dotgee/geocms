class AddThumbnailToLayers < ActiveRecord::Migration
  def change
    add_column :layers, :thumbnail, :string
  end
end
