require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new" do
    get :run_report
    assert_response :success
  end

end
