class ChangeDefaultValueOfContextsName < ActiveRecord::Migration
  def change
    change_column :contexts, :name, :string, default: ""
  end
end
