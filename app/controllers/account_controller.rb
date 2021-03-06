class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  before_filter :ip_filter

  # say something nice, you goof!  something sweet.
  def index
    if  logged_in? || Author.count > 0
      redirect_to :controller => 'editor'
    else
      redirect_to :action => 'signup'     
    end
  end

  def login
    return unless request.post?
    self.current_author = Author.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_author.remember_me
        cookies[:auth_token] = { :value => self.current_author.remember_token , :expires => self.current_author.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/account', :action => 'index')
      flash[:notice] = "Вход выполнен"
    else 
      flash[:notice] = "Неверное имя или пароль"
    end
  end

  def signup
    @author = Author.new(params[:author])
    return unless request.post?
    @author.save!
    self.current_author = @author
    redirect_back_or_default(:controller => '/editor', :action => 'index')
    flash[:notice] = "Спасибо за регистрацию!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_author.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "Выход выполнен"
    flash.keep
    redirect_back_or_default(:controller => '/user')
  end
end
