# encoding: UTF-8
module UsersHelper
  def user_name(user)
    link_to(user.login, root_path, title:user_tooltip(user))
  end

  def user_tooltip(user)
    s_('Tooltip|%{user} currently has %{points} %{karma}. They are %{roles}.') % {
      user:   user.first_name,
      points: user.karma,
      karma:  karma_symbol,
      roles:  user.roles.values_of(:name).to_sentence
    }
  end
end
