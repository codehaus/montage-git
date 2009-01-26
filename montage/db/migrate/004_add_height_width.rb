class AddHeightWidth < ActiveRecord::Migration
  def self.up
    add_column :exhibits, :height, :integer, :null=>true
    add_column :exhibits, :width, :integer, :null=>true
  end

  def self.down
    remove_column :exhibits, :height
    remove_column :exhibits, :width
  end
end
