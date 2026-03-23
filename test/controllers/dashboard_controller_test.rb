require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "show renders dashboard" do
    create(:company)
    create(:contact)
    create(:deal, stage: "lead")
    get root_path
    assert_response :success
    assert_includes response.body, "Dashboard"
    assert_includes response.body, "Pipeline Value"
  end
end
