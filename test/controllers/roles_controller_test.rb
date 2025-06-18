require "test_helper"

class RolesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get roles_index_url
    assert_response :success
  end

  test "should get show" do
    get roles_show_url
    assert_response :success
  end

  test "should get assign" do
    get roles_assign_url
    assert_response :success
  end

  test "should get remove" do
    get roles_remove_url
    assert_response :success
  end
end
