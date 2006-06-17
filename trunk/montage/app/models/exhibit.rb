class Exhibit < ActiveRecord::Base
  def to_s
    "Exhibit[id=#{id}, title=#{title}]"
  end
  
  def data_location(mode)
    #so we assume 10 billion exhibits and 100 entries max to keep performance reasonable
    # 00/00/00/00/00
    tmp_id = id
    result = ""

    for i in 0...5    
      result = "/" + prefix( "#{tmp_id % 100}", 2, "0" ) + result
      tmp_id = (tmp_id - (tmp_id % 100)) / 100
    end
    
    #Hardwired to jpeg for now
    if mode == "raw"
      prefix = "raw"
      suffix = ""
    else
      prefix = "scaled"
      suffix = "-#{mode}"
    end
    
    "./data/#{prefix}#{result}/#{prefix(id, 10, "0")}#{suffix}.jpg"
  end
  
  def prefix(val, count, prefix)
    string = "#{val}"
    while string.length() < count
      string = prefix + string
    end
    string
  end
end
