require 'test_helper'

class SortableControllerTest < ActionDispatch::IntegrationTest
  test "should get reorder" do
    get sortable_reorder_url
    assert_response :success
  end

end
