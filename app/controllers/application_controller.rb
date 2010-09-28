# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :instantiate_controller_and_action_names
  include AuthenticatedSystem

  def set_charsets
    if request.xhr?
      request.headers["Content-Type"] = "text/javascript; charset=windows-1251"
    else
      request.headers["Content-Type"] = "text/html; charset=windows-1251"
    end
  end

  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
  end
end
