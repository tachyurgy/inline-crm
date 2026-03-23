require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contact = create(:contact)
  end

  test "index renders successfully" do
    get contacts_path
    assert_response :success
    assert_includes response.body, @contact.full_name
  end

  test "show renders successfully" do
    get contact_path(@contact)
    assert_response :success
    assert_includes response.body, @contact.first_name
  end

  test "new renders successfully" do
    get new_contact_path
    assert_response :success
  end

  test "create with valid params" do
    assert_difference("Contact.count") do
      post contacts_path, params: { contact: { first_name: "Test", last_name: "User", email: "test@example.com", company_id: create(:company).id } }
    end
    assert_redirected_to contact_path(Contact.last)
  end

  test "create with invalid params" do
    assert_no_difference("Contact.count") do
      post contacts_path, params: { contact: { first_name: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "update via turbo_stream" do
    patch contact_path(@contact), params: { contact: { first_name: "Updated" } },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_equal "Updated", @contact.reload.first_name
  end

  test "destroy removes contact" do
    assert_difference("Contact.count", -1) do
      delete contact_path(@contact)
    end
    assert_redirected_to contacts_path
  end
end
