class AddIndexesToTables < ActiveRecord::Migration
  def change
    add_index :contexts, :account_id
    add_index :dimensions, :layer_id
    add_index :layers, :data_source_id
    add_index :preferences, :account_id
    add_index :taggings, [:tagger_id, :tagger_type]
    add_index :users, :account_id
  end
end
