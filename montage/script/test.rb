#!/opt/local/bin/ruby
require File.dirname(__FILE__) + '/../config/boot'
require 'RMagick'

img = Magick::Image::read(ARGV[0]).first

exif_entry = img.get_exif_by_entry("DateTime")

if exif_entry[0][1] != nil
  puts exif_entry[0][1]
  puts Time.parse(exif_entry[0][1].gsub(':', ''))
end     
