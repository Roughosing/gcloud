require "test_helper"

class FoldersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get folders_index_url
    assert_response :success
  end

  test "should get show" do
    get folders_show_url
    assert_response :success
  end

  test "should get create" do
    get folders_create_url
    assert_response :success
  end

  test "should get destroy" do
    get folders_destroy_url
    assert_response :success
  end
end
