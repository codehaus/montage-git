class AddCapturedAt < ActiveRecord::Migration
  def self.up
    add_column :exhibits, :captured_at, :datetime, :null=>true
  end

  def self.down
    remove_column :exhibits, :captured_at
  end
end
