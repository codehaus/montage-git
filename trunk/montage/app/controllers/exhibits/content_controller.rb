require 'RMagick'

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

      if mode == "200x200"
        thumb = img.scale(200, 200)
        thumb.write @exhibit.data_location(mode)
      end
      
      if mode == "800x800"
        thumb = img.scale(800, 800)
        thumb.write @exhibit.data_location(mode)
      end
      
    end
    
    send_file @exhibit.data_location(mode), :type => exhibit_type.mime_type, :disposition => "inline"
  end


end