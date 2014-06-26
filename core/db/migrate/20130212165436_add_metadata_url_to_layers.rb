class AddMetadataUrlToLayers < ActiveRecord::Migration
  def change
    add_column :layers, :metadata_url, :string
  end
end
