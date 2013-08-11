# encoding: UTF-8
# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutsHelper
  def page_title
    title_components = [configatron.app_name]
    
    title_components.unshift(current_account.name) if current_account

    saved_title = content_for(:title)
    title_components.unshift(saved_title) unless saved_title.blank?

    title_components.join(' • ')
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

  def page_stylesheet_tag
    controller = params[:controller]
    @page_stylesheet_tags ||= {}
    @page_stylesheet_tags[controller] ||= begin
      css_path = Pathname.pwd.
        join('app/assets/stylesheets/pages').
        join("#{controller}.css.sass")
      css_path.exist? ? stylesheet_link_tag("pages/#{controller}") : ''
    end
  end
end
