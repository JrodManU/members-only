require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jared)
  end

  test "only members should be allowed on new and create" do
    get new_post_path
    assert_redirected_to root_url
    assert_not flash.empty?
    post posts_path, params: { post: { title: "title", body: "body", user_id: @user.id } }
    assert_redirected_to root_url
    log_in_as(@user)
  end

end
