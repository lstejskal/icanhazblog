class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :admin?

  private  

  def current_user  
    @current_user ||= User.find(session[:user_id]) if session[:user_id]  
  end

  def admin?
    current_user.try(:admin?) || false
  end

  def deny_access
    flash[:alert] = "Please log in"
    redirect_to log_in_path
  end

  def admin_access_required
    deny_access unless admin?
  end

end
