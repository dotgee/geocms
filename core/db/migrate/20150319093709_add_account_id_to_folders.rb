class AddAccountIdToFolders < ActiveRecord::Migration
  def change
    add_column :geocms_folders, :account_id, :integer
  end
end
