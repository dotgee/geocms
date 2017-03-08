class AddQueryableToLayer < ActiveRecord::Migration
  def change
    add_column :layers, :queryable, :bool
  end
end
