require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  test "requires name" do
    company = build(:company, name: nil)
    assert_not company.valid?
    assert_includes company.errors[:name], "can't be blank"
  end

  test "has many contacts" do
    company = create(:company)
    create(:contact, company: company)
    assert_equal 1, company.contacts.count
  end

  test "has many deals" do
    company = create(:company)
    create(:deal, company: company)
    assert_equal 1, company.deals.count
  end

  test "logs activity on update" do
    company = create(:company, name: "Old Corp")
    company.update!(name: "New Corp")
    activity = company.activities.last
    assert_equal "updated", activity.action
    assert_includes activity.description, "Old Corp"
    assert_includes activity.description, "New Corp"
  end

  test "destroying company destroys contacts and deals" do
    company = create(:company)
    create(:contact, company: company)
    create(:deal, company: company)

    assert_difference("Contact.count", -1) do
      assert_difference("Deal.count", -1) do
        company.destroy
      end
    end
  end
end
