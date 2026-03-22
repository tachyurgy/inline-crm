require "test_helper"

class ActivityTest < ActiveSupport::TestCase
  test "requires action" do
    activity = build(:activity, action: nil)
    assert_not activity.valid?
    assert_includes activity.errors[:action], "can't be blank"
  end

  test "recent scope orders by created_at desc" do
    contact = create(:contact)
    old = contact.activities.create!(action: "called", description: "Old call", created_at: 2.hours.ago)
    recent = contact.activities.create!(action: "emailed", description: "Recent email")
    assert_equal recent, Activity.recent.first
  end

  test "for_feed limits results" do
    contact = create(:contact)
    55.times { contact.activities.create!(action: "noted", description: "Note") }
    assert_equal 50, Activity.for_feed.count
  end
end
