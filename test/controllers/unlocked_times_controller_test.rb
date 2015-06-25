require 'test_helper'

class UnlockedTimesControllerTest < ActionController::TestCase
  setup do
    @unlocked_time = unlocked_times(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:unlocked_times)
  end

  test "should get new" do
    get :run_report
    assert_response :success
  end

  test "should create unlocked_time" do
    assert_difference('UnlockedTime.count') do
      post :create, unlocked_time: { end_time: @unlocked_time.end_timL, start_time: @unlocked_time.start_time }
    end

    assert_redirected_to unlocked_time_path(assigns(:unlocked_time))
  end

  test "should show unlocked_time" do
    get :show, id: @unlocked_time
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @unlocked_time
    assert_response :success
  end

  test "should update unlocked_time" do
    patch :update, id: @unlocked_time, unlocked_time: { end_time: @unlocked_time.end_time, start_time: @unlocked_time.start_time }
    assert_redirected_to unlocked_time_path(assigns(:unlocked_time))
  end

  test "should destroy unlocked_time" do
    assert_difference('UnlockedTime.count', -1) do
      delete :destroy, id: @unlocked_time
    end

    assert_redirected_to unlocked_times_path
  end
end
