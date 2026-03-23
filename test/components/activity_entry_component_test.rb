require "test_helper"

class ActivityEntryComponentTest < ViewComponent::TestCase
  test "renders activity description" do
    contact = create(:contact, first_name: "Jane", last_name: "Doe")
    activity = contact.activities.create!(action: "updated", description: "Changed email")
    render_inline(ActivityEntryComponent.new(activity: activity))
    assert_text "Jane Doe"
    assert_text "Changed email"
  end

  test "renders time ago" do
    contact = create(:contact)
    activity = contact.activities.create!(action: "called", description: "Phone call", created_at: 1.hour.ago)
    render_inline(ActivityEntryComponent.new(activity: activity))
    assert_text "ago"
  end
end
