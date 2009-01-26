require File.dirname(__FILE__) + '/../test_helper'

class ExhibitTypeTest < Test::Unit::TestCase
  fixtures :exhibit_types

  def test_find_exhibit_type_for_filename
    assert ExhibitType.find_exhibit_type_for_filename("grue.jpg").key == "jpg"
  end
end
