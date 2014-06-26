class AddMetadataIdentifierToLayers < ActiveRecord::Migration
  def change
    add_column :layers, :metadata_identifier, :string
  end
end
