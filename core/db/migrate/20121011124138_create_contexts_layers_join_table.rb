class CreateContextsLayersJoinTable < ActiveRecord::Migration
  def up
    create_table :contexts_layers do |t|
      t.references :context, :layer
    end
    add_index :contexts_layers, [:context_id, :layer_id] # Optionnel
  end

  def down
    drop_table :contexts_layers
  end
end
