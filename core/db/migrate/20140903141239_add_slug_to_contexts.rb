class AddSlugToContexts < ActiveRecord::Migration
  def change
    add_column  :geocms_contexts, :slug, :string
    add_index   :geocms_contexts, :slug
  end
end
