class CreateLayers < ActiveRecord::Migration
  def change
    create_table :layers do |t|
      t.string :name
      t.string :wms_url
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
