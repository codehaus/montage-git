require 'ftools'
require 'RMagick'

class Exhibit < ActiveRecord::Base
  def to_s
    "Exhibit[id=#{id}, filename=#{filename}, title=#{title}]"
  end
  
  def data_location(mode)
    path = get_path()
    
    #Hardwired to jpeg for now
    if mode == "raw"
      "./data/raw/#{path}/#{filename}"
    else
      "./data/scaled/#{path}/#{mode}-#{filename}"
    end
  end
  
  def get_path()
    if created_at() and false
      return get_path_from_date()
    else
      return Exhibit.get_path_from_id(id)
    end
  end
  
    #so we assume 10 billion exhibits and 100 entries max to keep performance reasonable
    # 00/00/00/00/00
  def self.get_path_from_id(inputid)
    tmp_id = inputid
    path = ""

    0.upto(4) { |i| 
      path = "/" + path unless i == 0
      path = prefix( "#{tmp_id % 100}", 2, "0" ) + path
      tmp_id = (tmp_id - (tmp_id % 100)) / 100
    }
    path
  end
  
  def get_path_from_date()
    raise Exception.new("illegal call") unless created_at
    
    return created_at.strftime("%Y/%m/%d")
  end
  
  
  def make_data_location(mode)
    thumb_file = data_location(mode)
    thumb_dir = File.dirname(thumb_file)
        
    if not File.directory?(thumb_dir)
      File.makedirs(thumb_dir)
    end
  end
  
  def self.prefix(val, count, prefix)
    string = "#{val}"
    while string.length() < count
      string = prefix + string
    end
    string
  end
  
  def upload_file_from_web(incoming_file)
    #self.content_type = incoming_file.content_type
    puts("Server provided content-type : #{incoming_file.content_type}")
    self.filename = sanitize_filename(incoming_file.original_filename)
    self.title = self.filename
    #exhibit_type = ExhibitType.find_by_mime_type(incoming_file.content_type)
    exhibit_type = ExhibitType.find_exhibit_type_for_filename(incoming_file.original_filename)
    self.exhibit_type_id = exhibit_type.id if exhibit_type
    @temp_file = incoming_file
    @temp_file_type = "web"
  end
  
  def upload_file_from_filesystem(filename)
    #puts("Server provided content-type : #{incoming_file.content_type}")
    self.filename = sanitize_filename(filename)
    self.title = self.filename
    exhibit_type = ExhibitType.find_exhibit_type_for_filename(filename)
    self.exhibit_type_id = exhibit_type.id if exhibit_type
    @temp_file = filename
    @temp_file_type = "fs"
  end
  
  def after_save
    if @temp_file
      make_data_location("raw")
      
      if @temp_file_type == "web"
        File.open(data_location("raw"), "wb") do |f| 
          f.write(@temp_file.read)
        end
      end
      
      if @temp_file_type == "fs"
        File.open(data_location("raw"), "wb") do |f|
          f.write(IO.read(@temp_file))
        end
      end

      @temp_file = nil      
      img = Magick::Image::read(data_location("raw")).first
      self.width = img.columns
      self.height = img.rows
      
      exif_entry = img.get_exif_by_entry('DateTime')
      
      if exif_entry[0][1] != nil
        self.captured_at = Time.parse(exif_entry[0][1].gsub(':', ''))
      else
        puts "Unable to determine capture date/time"
      end
      #puts "Captured at: #{img.get_exif_by_entry('DateTime').inspect}"
      #img.get_exif_by_entry().each { |result|
      #  puts "result: #{result}"
      #}
      save!
    end
  end
  
  def sanitize_filename(file_name)
    # get only the filename, not the whole path (from IE)
    just_filename = File.basename(file_name) 
    # replace all non alphanumeric, underscore or periods with underscore
    just_filename.sub(/[^\w\.\-]/,'_') 
  end
end
