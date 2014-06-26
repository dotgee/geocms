class AddWmsVersionToDataSources < ActiveRecord::Migration
  def change
    add_column :data_sources, :wms_version, :string, :default => '1.1.1'
  end
end
