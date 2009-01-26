require File.dirname(__FILE__) + '/../test_helper'

class ExhibitTest < Test::Unit::TestCase
  fixtures :exhibits

  # Replace this with your real tests.
  def test_prefix
    assert Exhibit.prefix("12", 2, "0") == "12"
    assert Exhibit.prefix("12", 3, "0") == "012"
    assert Exhibit.prefix("0", 3, "n") == "nn0"
  end
  
  def test_data_location_default
    e = Exhibit.find_by_id(1)
    assert_equal "./data/scaled/00/00/00/00/01/320x200-default.jpg", e.data_location( '320x200' )
  end

  def test_data_location_raw
    e = Exhibit.find_by_id(1)
    assert_equal "./data/raw/00/00/00/00/01/default.jpg", e.data_location( 'raw' )
  end

  def test_get_path_from_id
    assert_equal '00/00/00/00/01',Exhibit.get_path_from_id(1)
    assert_equal '00/00/00/01/01',Exhibit.get_path_from_id(101)
  end
  
end
