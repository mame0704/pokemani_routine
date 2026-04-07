require "test_helper"

class ParentRole::AccountsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get parent_role_accounts_show_url
    assert_response :success
  end

  test "should get edit" do
    get parent_role_accounts_edit_url
    assert_response :success
  end
end
