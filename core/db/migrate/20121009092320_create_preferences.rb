class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.integer :account_id
      t.string :name, :value

      t.timestamps
    end
  end
end
