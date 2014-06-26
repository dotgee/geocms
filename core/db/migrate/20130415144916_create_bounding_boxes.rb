class CreateBoundingBoxes < ActiveRecord::Migration
  def change
    create_table :bounding_boxes do |t|
      t.string :crs
      t.float :minx
      t.float :miny
      t.float :maxx
      t.float :maxy
      t.references :layer

      t.timestamps
    end
    add_index :bounding_boxes, :layer_id
  end
end
