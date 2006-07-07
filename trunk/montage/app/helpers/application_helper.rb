require 'redcloth'

module ApplicationHelper

  def page_title(title)
    @page_title = title
  end
  
  def display_logo(display)
    @display_logo = display
  end
  
  def can_edit()
#    puts @request.inspect
    remote_addr = request.env["REMOTE_ADDR"] 
 #   puts "Remote_Addr #{remote_addr}"
    return true if remote_addr == "127.0.0.1" 
  #  return true if remote_addr == "192.168.0.4" 
    return false
  end
  
  def editable(object, field, can_edit=false, columns=55, rows=1, options={})
    real_object = self.instance_variable_get( "@#{object}" )
    real_object.reload
    initial_value = real_object.send( field )
    if ( ! can_edit )
      return initial_value
    end
    if ( initial_value == nil || initial_value == '' )
      initial_value = "<em>Click to edit #{field.to_s.gsub('_', ' ')}</em>"
    end

    html = <<END
  <div class="editable" id="#{object}_#{field}_#{object.object_id}_editable">#{initial_value}</div>
  <script type="text/javascript">
    //<![CDATA[
    new Ajax.InPlaceEditor('#{object}_#{field}_#{object.object_id}_editable', 
                           '#{url_for :controller=>"/ajax/#{Inflector.underscore( real_object.class.name )}", :action=>"set_#{object}_#{field}", :id=>real_object.id, *options }', 
                            {
                              cols:#{columns}, rows:#{rows}, 
                              loadTextURL:'#{url_for :controller=>"/ajax/#{Inflector.underscore( real_object.class.name )}", :action=>"get_#{object}_#{field}", :id=>real_object.id }'
                            } )
    //]]>
  </script>
END
    html
  end  
  
  
  def red_render( content )
    red = RedCloth.new content
    red.to_html
  end
  
  def editable_redcloth(object, field, can_edit=false, columns=55, rows=1, options={})
    real_object = self.instance_variable_get( "@#{object}" )
    real_object.reload
    raw_content = real_object.send( field )
    if ( ! can_edit )
      if ( raw_content == nil || raw_content == '' )
        return red_render( '' )
      else
        return red_render( raw_content )
      end
    end
    if ( raw_content == nil || raw_content == '' )
      raw_html = "<em>Click to edit #{field.to_s.gsub('_', ' ')}</em>"
    else
      raw_html = red_render(raw_content)
    end

    html = <<END
  <div class="editable" id="#{object}_#{field}_#{object.object_id}_editable">#{raw_html}</div>
  <script type="text/javascript">
    //<![CDATA[
    new Ajax.InPlaceEditor('#{object}_#{field}_#{object.object_id}_editable', 
                           '#{url_for :controller=>"/ajax/#{Inflector.underscore( real_object.class.name )}", :action=>"set_#{object}_#{field}", :id=>real_object.id, *options }', 
                            {
                              cols:#{columns}, rows:#{rows}, 
                              loadTextURL:'#{url_for :controller=>"/ajax/#{Inflector.underscore( real_object.class.name )}", :action=>"get_#{object}_#{field}", :id=>real_object.id }'
                            } )
    //]]>
  </script>
END
    html
  end  
end
