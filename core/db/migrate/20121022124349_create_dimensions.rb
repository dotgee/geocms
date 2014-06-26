class CreateDimensions < ActiveRecord::Migration
  def change
    create_table :dimensions do |t|
      t.string :value
      t.integer :layer_id

      t.timestamps
    end
  end
end
