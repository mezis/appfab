# encoding: UTF-8
class WelcomeController < ApplicationController
  STATIC_PAGES = %w(release-notes)

  def index
  end

  def fail
    raise RuntimeError.new("failed on purpose with: #{params.inspect}")
  end

  def static_page
    unless STATIC_PAGES.include? params[:page]
      render_error_page :not_found, message:_("We don't know about the page you're trying to access.")
      return
    end

    render params[:page].gsub('-','_')
  end
end
