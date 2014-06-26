class CreateTableMemberships < ActiveRecord::Migration
  def up
    create_table :memberships do |t|
      t.references :account, :user
    end
    add_index :memberships, [:account_id, :user_id]
  end
end
