module SessionsHelper

  def log_in(user)
    session[:user_id] =  user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: user_id)
    elsif user_id = cookies[:user_id]
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def remember(user)
    user.new_remember_token
    cookies.permenant.singed[:user_id] = id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.clear_remember_digest
    cookies.delete :user_id
    cookies.delete :remember_token
  end
end
