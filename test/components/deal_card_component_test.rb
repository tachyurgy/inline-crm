require "test_helper"

class DealCardComponentTest < ViewComponent::TestCase
  test "renders deal name and value" do
    deal = create(:deal, name: "Enterprise Sale", value: 100_000)
    render_inline(DealCardComponent.new(deal: deal))
    assert_text "Enterprise Sale"
    assert_text "$100,000"
  end

  test "renders company name" do
    company = create(:company, name: "Acme Corp")
    deal = create(:deal, company: company)
    render_inline(DealCardComponent.new(deal: deal))
    assert_text "Acme Corp"
  end

  test "is draggable" do
    deal = create(:deal)
    render_inline(DealCardComponent.new(deal: deal))
    assert_selector "[draggable='true']"
  end
end
