class AddDefaultToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :default, :boolean, :default => false
  end
end
