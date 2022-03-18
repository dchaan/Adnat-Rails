class ApplicationController < ActionController::Base
  before_action :auth
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def auth
    redirect_to login_path if !logged_in?
  end
end
