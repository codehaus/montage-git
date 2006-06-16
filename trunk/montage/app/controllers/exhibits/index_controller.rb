class Exhibits::IndexController < ApplicationController
  layout "standard", :except =>[ :rss,:atom] 
  
  def index
    id = params[:id]
    @exhibit = Exhibit.find_by_id( id )
    if ( ! @exhibit )
      return redirect_to( :controller=>"/home/index", :action=>'index' )
    end 
    
    @inner_exhibits = [ ]  
    
    ExhibitLink.find_all_by_outer_exhibit_id(@exhibit.id).each { |exhibit_link|
      @inner_exhibits << Exhibit.find_by_id(exhibit_link.inner_exhibit_id)
    }
    
    @outer_exhibits = [ ]  
    
    ExhibitLink.find_all_by_inner_exhibit_id(@exhibit.id).each { |exhibit_link|
      @outer_exhibits << Exhibit.find_by_id(exhibit_link.outer_exhibit_id)
    }
    
  end
end
