class Exhibits::ViewController < ApplicationController
  
  def index
    id = params[:id]
    @exhibit = Exhibit.find_by_id( id )
    if ( ! @exhibit )
      return redirect_to( :controller=>"/home/index", :action=>'index' )
    end 
    
  end
end
