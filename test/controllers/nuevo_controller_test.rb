require 'test_helper'

class NuevoControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
