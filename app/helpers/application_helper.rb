# encoding: UTF-8
module ApplicationHelper

  # wrapper for +content_tag+ that yields a url for +options+,
  # unless the current action matches +options+, in which case it
  # yields '#'.
  # suitable to generate navigation links.
  def content_tag_with_path_checking(tag, options = {})
    html_options = options.delete(:html) || {}

    if current_user
      options_to_match = options.reverse_merge(controller: 'ideas')
      is_current = (params.symbolize_keys.slice(*options_to_match.keys) == options_to_match)
      path = url_for(options_to_match.reverse_merge(action: 'index'))

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

  # conditional link_to that generates a disabled link when the condition fails
  # path a boolean to the +if+ options,
  # a +can?+ array of parameters to the +auth+ option,
  # or both.
  # 
  # e.g.
  #   can_link_to foo_path, if:(a || b), auth:[:update, Stuff]
  # 
  def can_link_to(*args, &block)
    options = args.last { |arg| arg.kind_of?(Hash) }.dup

    auth_criteria  = options.delete(:auth)
    auth_condition = auth_criteria.nil? ? true : can?(*auth_criteria)
    if_condition   = options.fetch(:if, true)

    if if_condition && auth_condition
      link_to(*args, &block)
    else
      options.slice!(:class, :id, :'data-placement', :'data-container')
      options[:class] = [options.fetch(:class, '').split + %w(disabled)].join(' ')
      options[:title] = not_authorized_message(*auth_criteria) if auth_criteria
      content_tag(:a, options, &block)
    end
  end
end
