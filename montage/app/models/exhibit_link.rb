class ExhibitLink < ActiveRecord::Base
  belongs_to :outer_links

  belongs_to :inner_links
  
end
