# encoding: UTF-8
module ApplicationHelper

  def page_title
    saved_title = content_for(:title)
    saved_title.blank? ? configatron.app_name : "#{saved_title} - #{configatron.app_name}"
  end

end
