class AddGeocmsFolderIdToGeocmsContext < ActiveRecord::Migration
  def change
    add_column :geocms_contexts, :folder_id, :integer
  end
end
