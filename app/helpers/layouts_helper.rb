# encoding: UTF-8
# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutsHelper
  def page_title
    saved_title = content_for(:title)
    saved_title.blank? ? configatron.app_name : "#{saved_title} - #{configatron.app_name}"
  end

  def title(page_title, options = {})
    content_for(:title) { strip_tags(page_title.to_s) }
    @show_title = options.fetch(:show_title, true)
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def body_id
    "#{params[:controller]}-#{params[:action]}".gsub(/\W/, '-').gsub(/--+/,'-')
  end
end
