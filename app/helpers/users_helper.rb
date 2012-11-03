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
      karma:  karma_symbol
    })

    lines.push(s_('Tooltip|They are %{roles}.') % {
      roles:  user.roles.values_of(:name).to_sentence
    }) if user.roles.any?

    safe_join(lines.compact, tag(:br))
  end
end
