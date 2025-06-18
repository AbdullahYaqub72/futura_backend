require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get transaction_totals_by_type" do
    get dashboard_transaction_totals_by_type_url
    assert_response :success
  end

  test "should get sales_summary" do
    get dashboard_sales_summary_url
    assert_response :success
  end

  test "should get recent_transactions" do
    get dashboard_recent_transactions_url
    assert_response :success
  end
end
