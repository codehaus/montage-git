ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'

  map.connect '', :controller => 'home/index', :action => 'index'
  
  #map.exhibits_content 'exhibits/:id/content', :controller => 'exhibits/content', :action => 'send', :mode => 'default'  
  map.exhibits_content 'exhibits/:id/content/:mode', :controller => 'exhibits/content', :action => 'send'  
  
  map.exhibits_index 'exhibits/:id', :controller => 'exhibits/index', :action => 'index'  
  map.exhibits_view 'exhibits/:id/view', :controller => 'exhibits/view', :action => 'index'
  

    

end
