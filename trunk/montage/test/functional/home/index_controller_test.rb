require File.dirname(__FILE__) + '../../test_helper'
require 'home/index_controller'

# Re-raise errors caught by the controller.
class Home::IndexController; def rescue_action(e) raise e end; end

class Home::IndexControllerTest < Test::Unit::TestCase
  def setup
    @controller = Home::IndexController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_index
    get :index
    assert_status :success
  end
end
