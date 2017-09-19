class AddAccountToDataSources < ActiveRecord::Migration
  def change
    add_column :geocms_data_sources, :account_id, :integer
  end
end
