class InsertExhibitTypes < ActiveRecord::Migration
  def self.up
    [ 
      { :key=>'jpg', :label=>'JPEG', :mime_type=>"image/jpeg" },
      { :key=>'png', :label=>'PNG', :mime_type=>"image/png" },
      { :key=>'mov', :label=>'MOV', :mime_type=>"movie/quicktime" },
    ].each{|e|
      scm_type = ScmType.new( e )
      scm_type.save!
    }
  end

  def self.down
  end
end
