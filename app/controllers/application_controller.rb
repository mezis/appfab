# encoding: UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_text_domain

  private

  def set_text_domain
    FastGettext.text_domain = 'socialp'
  end

end
