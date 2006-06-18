class InsertExhibits < ActiveRecord::Migration
  def self.up
    [ 
      { :title=>'Welcome to Montage', :exhibit_type_id => 1 },
    ].each{|data|
      o = Exhibit.new( data )
      o.save!
    }
  end

  def self.down    
  end
end
