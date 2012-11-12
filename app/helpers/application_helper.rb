# encoding: UTF-8
module ApplicationHelper

  def content_tag_with_path_checking(tag, options = {})
    html_options = options.delete(:html) || {}

    if current_user
      options_to_match = options.reverse_merge(controller: 'ideas', action: 'index')
      is_current = (params.symbolize_keys.slice(*options_to_match.keys) == options_to_match)
      path = url_for(options_to_match)

      if is_current
        classes = html_options.fetch(:class, '').split
        classes.push 'active'
        options[:class] = classes.join(' ')
      end
    else
      path = '#'
    end

    content_tag(tag, options) do
      yield path, is_current
    end
  end
end
