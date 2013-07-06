# encoding: UTF-8
module UsersHelper
  def user_name(user)
    link_to(user.first_name, user, title:user_tooltip(user), :"data-container" => '.container')
  end

  def user_tooltip_options(user)
    { data: { tooltip_url:user_path(user), placement: 'bottom', container: '.container' } }
  end

  def user_tooltip_text(user)
    lines = []
    lines.push(s_('Tooltip|%{user} currently has %{points} %{karma}.').html_safe % {
      user:   user.first_name,
      points: user.karma,
      karma:  user_karma_symbol
    })

    lines.push(s_('Tooltip|They are %{roles}.').html_safe % { roles: user_roles_sentence(user) }) if user.roles.any?

    safe_join(lines.compact, tag(:br))
  end

  def user_roles_sentence(user)
    user.roles.values_of(:name).map { |role| user_role_name(role).downcase }.to_sentence
  end

  def user_karma_symbol
    content_tag(:i, '', :class => 'icon-leaf karma')
  end

  def user_random_greeting(user)
    options = {
      user:user.login.first_name,
      day:Date.today.strftime('%A')
    }
    case rand(6)
      when 0 then _('Hi there %{user},')
      when 1 then _('Good morning %{user},')
      when 2 then _('Happy %{day} %{user},')
      when 3 then _('Good to see you %{user},')
      when 4 then _('%{user}, hello again!')
      when 5 then _('We\'ve missed you %{user}...')
    end % options
  end
end
