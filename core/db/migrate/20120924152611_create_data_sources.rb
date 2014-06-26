class CreateDataSources < ActiveRecord::Migration
  def change
    create_table :data_sources do |t|
      t.string :name
      t.string :wms
      t.string :wfs
      t.string :csw
      t.string :ogc

      t.timestamps
    end
    add_column :layers, :data_source_id, :integer
  end
end
