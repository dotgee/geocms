class CreateGeocmsFolder < ActiveRecord::Migration
  def change
    create_table :geocms_folders do |t|
      t.string      :name
      t.references  :user
      t.boolean     :visibility
      t.string      :slug
      t.timestamps
    end
    add_index :geocms_folders, :name, unique: true
    add_index :geocms_folders, :slug, unique: true
  end
end
