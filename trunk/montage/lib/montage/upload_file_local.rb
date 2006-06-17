
class Montage::UploadFileLocal

  def self.run
    cmd = UploadFileLocal.new
    cmd.run
  end

  def run
    eholder = Exhibit.find_by_id(ARGV[0])
    
    ARGV[1..-1].each { |arg|
      next unless File.file?(arg)
      puts "Uploading: #{arg}"      
      
      e = Exhibit.new()
      e.upload_file_from_filesystem(arg)
      e.save!
      
      el = ExhibitLink.new()
      el.exhibit_id = eholder.id
      el.inner_exhibit_id = e.id
      el.save!
    }
  end
end