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


  def render_error_page(error, options = {})
    render template:"errors/#{error}", locals:options.slice(:message), status:error
  end

end
