require 'fileutils'

def clean()
  base = File.dirname(__FILE__) + '/../..'
  puts base
  FileUtils.rm_f(Dir.glob("#{base}/log/*"))  
  FileUtils.rm_rf("#{base}/target")  
  FileUtils.mkdir_p("#{base}/target")
  
  FileUtils.rm_rf("#{base}/tmp")  
  FileUtils.mkdir_p("#{base}/tmp")
end

desc 'Cleans out temporary files'
task :clean => [:environment] do |t|
  clean
end
