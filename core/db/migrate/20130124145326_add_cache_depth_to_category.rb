class AddCacheDepthToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :ancestry_depth, :integer, :default => 0
    begin
    Category.rebuild_depth_cache!
    rescue
	puts "depth cache removed"
    end
  end
end
