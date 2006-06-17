
class Ajax::ExhibitController < ApplicationController
  
  def get_exhibit
    Exhibit.find_by_id(params[:id])
  end
  

  def get_exhibit_title
    @exhibit = get_exhibit()
    render :text=>@exhibit.title, :layout=>false
  end
  
  def set_exhibit_title
    @exhibit = get_exhibit()
    @exhibit.title = params[:value]
    @exhibit.save!
    render :text=>@exhibit.title, :layout=>false
  end

  def get_exhibit_short_description
    @exhibit = get_exhibit()
    if not @exhibit.short_description
      render :text=>"Please enter a short description for this exhibit", :layout=>false
    else
      render :text=>@exhibit.short_description, :layout=>false
    end    
  end

  def set_exhibit_short_description
    @exhibit = get_exhibit()
    @exhibit.short_description = params[:value]
    @exhibit.save!
    render :text=>@exhibit.short_description, :layout=>false
  end
  
  def get_exhibit_long_description
    @exhibit = get_exhibit()
    if not @exhibit.long_description
      render :text=>"Please enter a long description for this exhibit", :layout=>false
    else
      render :text=>@exhibit.long_description, :layout=>false
    end    
  end

  def set_exhibit_long_description
    @exhibit = get_exhibit()
    @exhibit.long_description = params[:value]
    @exhibit.save!
    render :text=>@exhibit.long_description, :layout=>false
  end

end