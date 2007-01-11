require File.dirname(__FILE__) + '/../test_helper'

class ExhibitTest < Test::Unit::TestCase
  fixtures :exhibits

  # Replace this with your real tests.
  def test_prefix
    e = Exhibit.find_by_id(1)
    assert e.prefix("12", 2, "0") == "12"
    assert e.prefix("12", 3, "0") == "012"
    assert e.prefix("0", 3, "n") == "nn0"
  end
  
  def test_data_location_default
    e = Exhibit.find_by_id(1)
    assert_equal "./data/scaled/00/00/00/00/01/0000000001-default.jpg", e.data_location( 'default' )
  end

  def test_data_location_raw
    e = Exhibit.find_by_id(1)
    assert_equal "./data/raw/00/00/00/00/01/0000000001.jpg", e.data_location( 'raw' )
  end
  
end
