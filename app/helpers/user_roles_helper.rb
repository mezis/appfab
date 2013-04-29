# encoding: UTF-8
module UserRolesHelper

  def user_role_name(role)
    role = role.to_sym if role.kind_of?(String)
    case role
    when :benevolent_dictator then s_('User role|Benevolent dictator')
    when :product_manager     then s_('User role|Product manager')
    when :architect           then s_('User role|Architect')
    when :designer            then s_('User role|Designer')
    when :developer           then s_('User role|Developer')
    when :account_owner       then s_('User role|Account owner')
    when :submitter           then s_('User role|Submitter')
    end
  end

end
