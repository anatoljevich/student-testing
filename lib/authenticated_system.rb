module AuthenticatedSystem
  protected
    # Returns true or false if the user is logged in.
    # Preloads @current_author with the user model if they're logged in.
    def logged_in?
      current_author != :false
    end
    
    # Accesses the current author from the session.
    def current_author
      @current_author ||= (session[:author] && Author.find_by_id(session[:author])) || :false
    end
    
    # Store the given author in the session.
    def current_author=(new_author)
      session[:author] = (new_author.nil? || new_author.is_a?(Symbol)) ? nil : new_author.id
      @current_author = new_author
    end
    
    # Check if the author is authorized.
    #
    # Override this method in your controllers if you want to restrict access
    # to only a few actions or if you want to check if the author
    # has the correct rights.
    #
    # Example:
    #
    #  # only allow nonbobs
    #  def authorize?
    #    current_author.login != "bob"
    #  end
    def authorized?
      true
    end

    # Filter method to enforce a login ip requirement.
    #
    def ip_filter
      return true unless Tests::Config::enable_ip_filter
      Tests::Config::allowed_ip.include?(request.remote_ip) ? true : access_denied
    end

    # Returns true or false if the allowed ip.
    def allowed_ip?
      return true unless Tests::Config::enable_ip_filter
      Tests::Config::allowed_ip.include?(request.remote_ip)
    end


    # Filter method to enforce a login requirement.
    #
    # To require logins for all actions, use this in your controllers:
    #
    #   before_filter :login_required
    #
    # To require logins for specific actions, use this in your controllers:
    #
    #   before_filter :login_required, :only => [ :edit, :update ]
    #
    # To skip this in a subclassed controller:
    #
    #   skip_before_filter :login_required
    #
    def login_required
      username, passwd = get_auth_data
      self.current_author ||= Author.authenticate(username, passwd) || :false if username && passwd
      logged_in? && authorized? ? true : access_denied
    end
    
    # Redirect as appropriate when an access request fails.
    #
    # The default action is to redirect to the login screen.
    #
    # Override this method in your controllers if you want to have special
    # behavior in case the author is not authorized
    # to access the requested action.  For example, a popup window might
    # simply close itself.
    def access_denied
      respond_to do |accepts|
        accepts.html do
          store_location
          redirect_to :controller => '/user'
        end
        accepts.xml do
          headers["Status"]           = "Unauthorized"
          headers["WWW-Authenticate"] = %(Basic realm="Web Password")
          render :text => "Неверное имя или пароль", :status => '401 Unauthorized'
        end
      end
      false
    end  
    
    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.request_uri
    end
    
    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default)
      session[:return_to] ? redirect_to(session[:return_to]) : redirect_to(default)
      session[:return_to] = nil
    end
    
    # Inclusion hook to make #current_author and #logged_in?
    # available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_author, :logged_in?
      base.send :helper_method, :request, :allowed_ip?      
    end

    # When called with before_filter :login_from_cookie will check for an :auth_token
    # cookie and log the user back in if apropriate
    def login_from_cookie
      return unless cookies[:auth_token] && !logged_in?
      user = Author.find_by_remember_token(cookies[:auth_token])
      if user && user.remember_token?
        user.remember_me
        self.current_author = user
        cookies[:auth_token] = { :value => self.current_author.remember_token , :expires => self.current_author.remember_token_expires_at }
        flash[:notice] = "Вход выполнен"
      end
    end

  private
    @@http_auth_headers = %w(X-HTTP_AUTHORIZATION HTTP_AUTHORIZATION Authorization)
    # gets BASIC auth info
    def get_auth_data
      auth_key  = @@http_auth_headers.detect { |h| request.env.has_key?(h) }
      auth_data = request.env[auth_key].to_s.split unless auth_key.blank?
      return auth_data && auth_data[0] == 'Basic' ? Base64.decode64(auth_data[1]).split(':')[0..1] : [nil, nil] 
    end
end
