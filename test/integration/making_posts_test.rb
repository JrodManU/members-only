require 'test_helper'

class MakingPostsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jared)
  end

  test "non-members can't access new" do
    get new_post_path
    assert_redirected_to root_url
    assert_not flash.empty?
  end

  test "non-members can't create" do
    post posts_path, params: { post: { title: "w43ed465768o7vb8n9orf5ytkiv7", body: "bodybodybody", user_id: @user.id } }
    assert_redirected_to root_url
    follow_redirect!
    assert_select "div.post", { text: "w43ed465768o7vb8n9orf5ytkiv7", count: 0 }
  end

  test "members can access new" do
    log_in_as @user
    get new_post_path
    assert_template 'posts/new'
  end

  test "members can create successfully" do
    log_in_as @user
    post posts_path, params: { post: { title: "w43ed465768o7vb8n9orf5ytkiv7", body: "bodybodybody", user_id: @user.id } }
    follow_redirect!
    assert_template 'posts/index'
    assert_select "div.post", "w43ed465768o7vb8n9orf5ytkiv7"
  end
end
