require 'RMagick'
require 'ftools'

class Exhibits::ContentController < ApplicationController
  #layout "standard", :except =>[ :content]
  
  def send(mode)
    id = params[:id]
    mode = params[:mode]
    @exhibit = Exhibit.find_by_id( id )
    if ( ! @exhibit )
      return redirect_to( :controller=>"/home/index", :action=>'index' )
    end 
    
    mode = "200x200" if mode == "default"
    
    exhibit_type = ExhibitType.find_by_id(@exhibit.exhibit_type_id)
  
    puts "sending... #{mode}"
    
    if not File.exists?(@exhibit.data_location(mode))
      raw_file = @exhibit.data_location("raw")
      img = Magick::Image::read(raw_file).first
      
      if mode == "100x100" or mode == "200x200" or mode == "400x400" or mode == "600x600" or mode == "800x800"
        thumb = scale(img, mode)
      end
      
      if thumb
        @exhibit.make_data_location( mode )
        thumb.write @exhibit.data_location(mode) {self.quality=50}
      end
      
      puts "Input: #{img.columns}x#{img.rows}"
      
    end
    
    send_file @exhibit.data_location(mode), :type => exhibit_type.mime_type, :disposition => "inline"
  end
  
  def scale(image, geometry)
    image.change_geometry!(geometry) { |cols, rows, img| 
      return img.resize(cols, rows)
    }
  end


end