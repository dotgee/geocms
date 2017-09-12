class AddQueryableToLayer < ActiveRecord::Migration
  def change
    add_column :geocms_layers, :queryable, :bool
  end
end
