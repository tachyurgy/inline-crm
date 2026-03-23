require "test_helper"

class EditableFieldComponentTest < ViewComponent::TestCase
  test "renders display value" do
    contact = create(:contact, first_name: "Jane")
    render_inline(EditableFieldComponent.new(record: contact, field: :first_name))
    assert_text "Jane"
    assert_text "First name"
  end

  test "renders placeholder when blank" do
    contact = create(:contact, phone: nil)
    render_inline(EditableFieldComponent.new(record: contact, field: :phone))
    assert_text "Click to edit"
  end

  test "includes inline-edit stimulus controller" do
    contact = create(:contact)
    render_inline(EditableFieldComponent.new(record: contact, field: :first_name))
    assert_selector "[data-controller='inline-edit']"
  end

  test "renders textarea for textarea type" do
    contact = create(:contact)
    render_inline(EditableFieldComponent.new(record: contact, field: :notes, input_type: :textarea))
    assert_selector "textarea", visible: :all
  end

  test "renders number field for number type" do
    deal = create(:deal, value: 5000)
    render_inline(EditableFieldComponent.new(record: deal, field: :value, input_type: :number))
    assert_selector "input[type='number']", visible: :all
  end
end
