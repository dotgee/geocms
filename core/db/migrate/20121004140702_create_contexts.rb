class CreateContexts < ActiveRecord::Migration
  def change
    create_table :contexts do |t|
      t.string :name, :default => "Untitled map"
      t.text :description, :default => nil
      t.boolean :public, :default   => false
      t.integer :zoom, :default     => 10
      t.float :minx, :default       => nil
      t.float :maxx, :default       => nil
      t.float :miny, :default       => nil
      t.float :maxy, :default       => nil
      t.string :uuid
      t.float :center_lng, :default => -1.676235
      t.float :center_lat, :default => 48.118454
      t.integer :account_id, :null  => false
      t.timestamps
    end
    add_index :contexts, :uuid, unique: true
  end
end
