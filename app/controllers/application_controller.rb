class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You do not have authorization to do this."
    redirect_to home_path
  end

  private
  def current_user
    # ||= means leave @current_user alone if it is defined (i.e. non-nil).  Otherwise, set it equal to ...
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  def logged_in?
    current_user
  end
  helper_method :logged_in?
  
  def check_login
    redirect_to login_url, alert: "You need to log in to view this page." if current_user.nil?
  end

end
