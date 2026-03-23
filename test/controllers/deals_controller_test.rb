require "test_helper"

class DealsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deal = create(:deal, stage: "lead")
  end

  test "index renders pipeline" do
    get deals_path
    assert_response :success
    assert_includes response.body, @deal.name
  end

  test "show renders successfully" do
    get deal_path(@deal)
    assert_response :success
  end

  test "new renders successfully" do
    get new_deal_path
    assert_response :success
  end

  test "create with valid params" do
    company = create(:company)
    assert_difference("Deal.count") do
      post deals_path, params: { deal: { name: "Big Deal", stage: "lead", value: 50000, company_id: company.id } }
    end
    assert_redirected_to deals_path
  end

  test "update via turbo_stream" do
    patch deal_path(@deal), params: { deal: { name: "Updated Deal" } },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_equal "Updated Deal", @deal.reload.name
  end

  test "move changes deal stage" do
    patch move_deal_path(@deal), params: { deal: { stage: "qualified" } },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_equal "qualified", @deal.reload.stage
  end

  test "move with invalid stage returns error" do
    patch move_deal_path(@deal), params: { deal: { stage: "bogus" } },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :unprocessable_entity
  end

  test "destroy removes deal" do
    assert_difference("Deal.count", -1) do
      delete deal_path(@deal)
    end
    assert_redirected_to deals_path
  end
end
