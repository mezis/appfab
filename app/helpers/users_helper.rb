# encoding: UTF-8
module UsersHelper
  def user_name(user)
    link_to(user.login, root_path)
  end
end
