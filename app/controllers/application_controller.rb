# encoding: UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  include Traits::RedirectToHttps

  before_filter :set_text_domain

  protected

  def reset_login
    @current_account = nil
    @current_user    = nil
  end

  private

  def set_text_domain
    FastGettext.available_locales = [:en]
    FastGettext.text_domain = 'app_fab'
    session[:locale] = I18n.locale = FastGettext.set_locale(:en)
  end


  def current_user
    return nil unless current_login && current_account
    @current_user ||= current_account.users.find_by_login_id(current_login.id)
  end
  helper_method :current_user


  def current_account
    return unless current_login
    @current_account ||= begin
      (account_id = session[:account_id].to_i) &&
      current_login.accounts.find_by_id(account_id) ||
      current_login.accounts.first
    end
  end
  helper_method :current_account

  def current_account=(account)
    if @current_account != account
      flash[:account_switch] = _('You just switched to viewing the "%{name}" team') % { name:account.name }
    end
    @current_account = nil
    @current_user    = nil
    session[:account_id] = account.id
  end


  def require_account!
    return true if current_account
    render_error_page :missing_account
  end


  def acting_real_user
    real_user = User.find_by_id(session[:real_user_id])

    if real_user == current_user
      session.delete(:real_user_id) and return
    else
      real_user
    end
  end
  helper_method :acting_real_user


  def acting_real_user=(user)
    if user.nil?
      session.delete(:real_user_id)
    elsif user.kind_of?(User)
      session[:real_user_id] = user.id
    else
      raise ArgumentError
    end
  end


  def render_error_page(error, options = {})
    status = case error
    when :missing_account then :bad_request
    else error
    end
    render template:"errors/#{error}", locals:options.slice(:message), status:status
  end


  rescue_from CanCan::AccessDenied do |exception|
    render_error_page :forbidden, message:exception.message
  end

end
