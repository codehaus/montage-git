class ExhibitType < ActiveRecord::Base
  def self.find_exhibit_type_for_filename(filename)
    if filename =~ /\.jpg$/i or filename =~ /\.jpeg/i
      return ExhibitType.find_by_key("jpg")
    end

    if filename =~ /\.png$/i
      return ExhibitType.find_by_key("png")
    end
  end  
end
