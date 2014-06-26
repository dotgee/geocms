class FixColumns < ActiveRecord::Migration
  def change
    remove_column :layers, :wms_url
    add_column :data_sources, :rest, :string
  end
end
