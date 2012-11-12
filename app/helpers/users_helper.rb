# encoding: UTF-8
module UsersHelper
  def user_name(user)
    link_to(user.login, root_path, title:user_tooltip(user))
  end

  def user_tooltip(user)
    lines = []
    lines.push(s_('Tooltip|%{user} currently has %{points} %{karma}.') % {
      user:   user.first_name,
      points: user.karma,
      karma:  user_karma_symbol
    })

    lines.push(s_('Tooltip|They are %{roles}.') % { roles: user_roles_sentence(user) }) if user.roles.any?

    safe_join(lines.compact, tag(:br))
  end

  def user_roles_sentence(user)
    user.roles.values_of(:name).map { |role| user_role_name(role).downcase }.to_sentence
  end

  def user_karma_symbol
    content_tag(:i, '', :class => 'icon-leaf karma')
  end
end
