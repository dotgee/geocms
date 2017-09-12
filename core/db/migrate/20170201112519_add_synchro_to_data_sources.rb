class AddSynchroToDataSources < ActiveRecord::Migration
  def change
    add_column :geocms_data_sources, :synchro, :boolean
  end
end
