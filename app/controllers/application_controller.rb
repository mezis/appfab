# encoding: UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_text_domain

  private

  def set_text_domain
    FastGettext.available_locales = [:en, :fr]
    FastGettext.text_domain = 'app_fab'
    session[:locale] = I18n.locale = FastGettext.set_locale(:en)
  end

  def current_account
    @current_account ||= current_user.andand.account
  end
  helper_method :current_account


  def require_account!
    return true if current_account
    render_error_page :bad_request, message: _('You need to be attached to an account before you can access this page. Time to speak to your account manager!')
    true
  end


  def render_error_page(error, options = {})
    render template:"errors/#{error}", locals:options.slice(:message), status:error
  end


  rescue_from CanCan::AccessDenied do |exception|
    render_error_page :forbidden, message:exception.message
  end

end
