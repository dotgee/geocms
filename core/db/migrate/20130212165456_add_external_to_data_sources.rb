class AddExternalToDataSources < ActiveRecord::Migration
  def change
    add_column :data_sources, :external, :boolean, :default => true
  end
end
