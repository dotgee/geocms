class CreateGeocmsCategorizations < ActiveRecord::Migration
  def change
    rename_table :geocms_categories_layers, :geocms_categorizations
  end
end
