class AddByDefaultToContexts < ActiveRecord::Migration
  def change
    add_column :geocms_contexts, :by_default, :boolean
  end
end
