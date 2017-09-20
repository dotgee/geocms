class ChangeColumnToGeocmsLayers < ActiveRecord::Migration
  def change
     change_column_default :geocms_layers, :queryable , true
     change_column_null    :geocms_layers, :queryable , true
  end
end
