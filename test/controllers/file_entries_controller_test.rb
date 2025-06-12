require "test_helper"

class FileEntriesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get file_entries_create_url
    assert_response :success
  end

  test "should get show" do
    get file_entries_show_url
    assert_response :success
  end

  test "should get destroy" do
    get file_entries_destroy_url
    assert_response :success
  end
end
