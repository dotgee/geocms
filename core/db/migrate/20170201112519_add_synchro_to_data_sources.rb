class AddSynchroToDataSources < ActiveRecord::Migration
  def change
    add_column :data_sources, :synchro, :boolean
  end
end
