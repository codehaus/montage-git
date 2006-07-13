require 'redcloth'

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

  def get_exhibit_excerpt
    @exhibit = get_exhibit()
    if not @exhibit.excerpt
      render :text=>"Please enter an excerpt for this exhibit", :layout=>false
    else
      render :text=>@exhibit.excerpt, :layout=>false
    end    
  end

  def set_exhibit_excerpt
    @exhibit = get_exhibit()
    @exhibit.excerpt = params[:value]
    @exhibit.save!
    render :text=>@exhibit.excerpt, :layout=>false
  end
  
  def get_exhibit_description
    @exhibit = get_exhibit()
    if not @exhibit.description
      render :text=>"Please enter a description for this exhibit", :layout=>false
    else
      render :text=>@exhibit.description, :layout=>false
    end    
  end

  def set_exhibit_description
    @exhibit = get_exhibit()
    @exhibit.description = params[:value]
    @exhibit.save!
    
    red = RedCloth.new @exhibit.description
    render :text=>red.to_html, :layout=>false
  end

end