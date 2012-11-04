# encoding: UTF-8
module ApplicationHelper

  def page_title
    saved_title = content_for(:title)
    saved_title.blank? ? configatron.app_name : "#{saved_title} - #{configatron.app_name}"
  end

  def content_tag_with_path_checking(tag, path, options = {})
    is_current = (request.fullpath == path)

    if is_current
      classes = options.fetch(:class, '').split
      classes.push 'active'
      options[:class] = classes.join(' ')
    end

    content_tag(tag, options) do
      yield path, is_current
    end
  end
end
