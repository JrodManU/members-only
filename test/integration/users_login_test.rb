require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jared)
  end

  test "successful login and logout" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email, password: 'password', remember: true } }
    assert_redirected_to @user
    user = assigns(:user)
    delete logout_path
    assert_nil user.reload.remember_digest
    assert_redirected_to root_url
  end

  test "invalid login" do
    get login_path
    post login_path, params: { session: { email: @user.email, password: 'notthepassword', remember: false } }
    assert_template 'sessions/new'
    assert_not flash.empty?
  end

  test "successful login and remember" do
    get login_path
    post login_path, params: { session: { email: @user.email, password: 'password', remember: true } }
    user = assigns(:user)
    assert_not user.remember_token.nil?
    assert_equal user.remember_token, cookies['remember_token']
  end

  test "succesful forget" do
    post login_path, params: { session: { email: @user.email, password: 'password', remember: true } }
    post login_path, params: { session: { email: @user.email, password: 'password', remember: false } }
    assert_nil cookies[:remember_token]
    assert_nil cookies[:user_id]
  end
end
