class CreateExhibits < ActiveRecord::Migration
  def self.up
    create_table :exhibit_types do |t|
      t.column :key, :string, :null=>false
      t.column :label, :string, :null=>false
      t.column :mime_type, :string, :null=>false
    end
    
    create_table :exhibits do |t|
      # t.column :name, :string
      t.column :title, :string, :null=>false
      t.column :exhibit_type_id, :integer, :null=>false
    end
    fk( :exhibits, :exhibit_type )

    create_table :exhibit_links do |t|
      #Parent / Child doesn't describe the linkage properly
      t.column :exhibit_id, :integer, :null=>false  
      t.column :inner_exhibit_id, :integer, :null=>false  
    end
    
    fk_exactly( :exhibit_links, :exhibit_id, :exhibits )
    fk_exactly( :exhibit_links, :inner_exhibit_id, :exhibits )
  end

  def self.down
    drop_table :exhibit_links
    drop_table :exhibits
  end
end
