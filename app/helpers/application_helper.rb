# encoding: UTF-8
module ApplicationHelper

  def page_title
    saved_title = content_for(:title)
    saved_title.blank? ? configatron.app_name : "#{saved_title} - #{configatron.app_name}"
  end

  def tshirt_size_options
    options_for_select([['XS', 1], ['S', 2], ['M', 3], ['L', 4]]) 

  def karma_symbol
    content_tag(:i, '', :class => 'icon-leaf karma')
  end
end
