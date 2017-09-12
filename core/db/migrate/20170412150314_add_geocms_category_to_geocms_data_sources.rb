class AddGeocmsCategoryToGeocmsDataSources < ActiveRecord::Migration
  def change
    add_reference :geocms_data_sources, :geocms_category, index: true, foreign_key: true
  end
end
