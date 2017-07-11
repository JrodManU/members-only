require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end

class ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password', remember: true)
    post login_path, params: { session: { email: user.email, password: password, remember: remember } }
  end
end
