class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!

  check_authorization :if => :inside_admin_area?

  rescue_from CanCan::AccessDenied do |exception|
    render :template => 'shared/forbidden'
  end

private
  ### before filters
  
  def require_admin!
    render :template => 'shared/admin_required' if !current_user.admin?
  end
  
  def save_return_to_url
    session[:return_to] = path if (path = params[:return_to]) && path =~ /\A\//
  end
  
  
  ### helpers
  
  def redirect_back(default_url = nil)
    redirect_to(session.delete(:return_to) || :back)
  rescue RedirectBackError
    redirect_to(default_url || root_path)
  end

  def inside_admin_area?
    controller_path =~ /\Aadmin/
  end

  def public_content?
    controller_name == "topics"
  end

  def authenticate_user!
    super unless public_content?
  end
end
