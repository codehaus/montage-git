class Exhibits::IndexController < ApplicationController
  
  def index
    id = params[:id]
    @exhibit = Exhibit.find_by_id( id )
    if ( ! @exhibit )
      return redirect_to( :controller=>"/home/index", :action=>'index' )
    end 
    
    @inner_exhibits = [ ]  
    
    ExhibitLink.find_all_by_exhibit_id(@exhibit.id).each { |exhibit_link|
      @inner_exhibits << Exhibit.find_by_id(exhibit_link.inner_exhibit_id)
    }
    
    @outer_exhibits = [ ]  
    
    ExhibitLink.find_all_by_inner_exhibit_id(@exhibit.id).each { |exhibit_link|
      @outer_exhibits << Exhibit.find_by_id(exhibit_link.exhibit_id)
    }
    
  end
  
  def _editable_get_exhibit_title
    @exhibit = Exhibit.find_by_key( params[:id] )
    render :text=>@exhibit.title, :layout=>false
  end
  
  def upload
  puts "uploading new school!"
    id = params[:id]
    @exhibit = Exhibit.find_by_id( id )

    e = Exhibit.new()
    e.title = 'New image'
    e.upload_file_from_web( @params['data_file'] )
    e.save!
    
    el = ExhibitLink.new()
    el.exhibit_id = @exhibit.id
    el.inner_exhibit_id = e.id
    el.save!
    
    
    redirect_to :action => 'index', :id => @exhibit.id
  end
end
