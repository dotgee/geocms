class AddImageToContext < ActiveRecord::Migration
  def change
    add_column :contexts, :preview, :string
  end
end
