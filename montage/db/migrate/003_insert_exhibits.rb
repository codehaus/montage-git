class InsertExhibits < ActiveRecord::Migration
  def self.up
      create_table :users do |t|
        t.column :email, :string, :null=>false
        t.column :full_name, :string, :null=>false
      end
      
      create_table :roles do |t|
        t.column :label, :string, :null=>false
        t.column :user_id, :integer, :null=>true
      end

      create_table :user_roles do |t|
        t.column :label, :string, :null=>false
        t.column :user_id, :integer, :null=>true
      end
  end

  def self.down    
  end
end
