require "test_helper"

class DealTest < ActiveSupport::TestCase
  test "requires name" do
    deal = build(:deal, name: nil)
    assert_not deal.valid?
    assert_includes deal.errors[:name], "can't be blank"
  end

  test "validates stage inclusion" do
    deal = build(:deal, stage: "invalid_stage")
    assert_not deal.valid?
    assert_includes deal.errors[:stage], "is not included in the list"
  end

  test "defaults stage to lead" do
    deal = Deal.new(name: "Test", company: create(:company))
    deal.valid?
    assert_equal "lead", deal.stage
  end

  test "validates value is not negative" do
    deal = build(:deal, value: -100)
    assert_not deal.valid?
  end

  test "formatted_value formats currency" do
    deal = build(:deal, value: 150_000)
    assert_equal "$150,000", deal.formatted_value
  end

  test "formatted_value returns N/A for nil" do
    deal = build(:deal, value: nil)
    assert_equal "N/A", deal.formatted_value
  end

  test "logs stage change activity" do
    deal = create(:deal, stage: "lead")
    deal.update!(stage: "qualified")
    activity = deal.activities.last
    assert_equal "updated", activity.action
    assert_includes activity.description, "Lead"
    assert_includes activity.description, "Qualified"
  end

  test "sets position automatically" do
    company = create(:company)
    deal1 = create(:deal, company: company, stage: "lead")
    deal2 = create(:deal, company: company, stage: "lead")
    assert deal2.position > deal1.position
  end

  test "pipeline scope excludes won and lost" do
    company = create(:company)
    create(:deal, company: company, stage: "lead")
    create(:deal, company: company, stage: "won")
    create(:deal, company: company, stage: "lost")
    assert_equal 1, Deal.pipeline.count
  end
end
