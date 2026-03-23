require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company = create(:company)
  end

  test "index renders successfully" do
    get companies_path
    assert_response :success
    assert_includes response.body, @company.name
  end

  test "show renders successfully" do
    get company_path(@company)
    assert_response :success
  end

  test "new renders successfully" do
    get new_company_path
    assert_response :success
  end

  test "create with valid params" do
    assert_difference("Company.count") do
      post companies_path, params: { company: { name: "Acme Corp" } }
    end
    assert_redirected_to company_path(Company.last)
  end

  test "update via turbo_stream" do
    patch company_path(@company), params: { company: { name: "Updated Corp" } },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_equal "Updated Corp", @company.reload.name
  end

  test "destroy removes company" do
    assert_difference("Company.count", -1) do
      delete company_path(@company)
    end
    assert_redirected_to companies_path
  end
end
