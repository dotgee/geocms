class RenameColumnExternalInDataSources < ActiveRecord::Migration
  def change
    rename_column :data_sources, :external, :not_internal
  end
end
