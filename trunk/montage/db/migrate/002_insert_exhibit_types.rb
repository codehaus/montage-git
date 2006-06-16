class InsertExhibitTypes < ActiveRecord::Migration
  def self.up
    [ 
      { :key=>'jpg', :label=>'JPEG', :mime_type=>"image/jpeg" },
      { :key=>'png', :label=>'PNG', :mime_type=>"image/png" },
      { :key=>'mov', :label=>'MOV', :mime_type=>"movie/quicktime" },
    ].each{|data|
      o = ExhibitType.new( data )
      o.save!
    }
  end

  def self.down
  end
end
