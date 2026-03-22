require "test_helper"

class ContactTest < ActiveSupport::TestCase
  test "requires first_name" do
    contact = build(:contact, first_name: nil)
    assert_not contact.valid?
    assert_includes contact.errors[:first_name], "can't be blank"
  end

  test "validates email format" do
    contact = build(:contact, email: "not-an-email")
    assert_not contact.valid?
    assert_includes contact.errors[:email], "is invalid"
  end

  test "allows blank email" do
    contact = build(:contact, email: "")
    assert contact.valid?
  end

  test "full_name combines first and last name" do
    contact = build(:contact, first_name: "John", last_name: "Doe")
    assert_equal "John Doe", contact.full_name
  end

  test "full_name works with only first name" do
    contact = build(:contact, first_name: "Jane", last_name: nil)
    assert_equal "Jane", contact.full_name
  end

  test "logs activity on update" do
    contact = create(:contact, first_name: "Alice")
    contact.update!(first_name: "Bob")
    activity = contact.activities.last
    assert_equal "updated", activity.action
    assert_includes activity.description, "Alice"
    assert_includes activity.description, "Bob"
  end

  test "company is optional" do
    contact = build(:contact, company: nil)
    assert contact.valid?
  end
end
