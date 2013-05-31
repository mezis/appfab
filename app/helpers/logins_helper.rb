module LoginsHelper
  
  def login_other_accounts
    @login_other_accounts ||= begin
      (current_login.users.with_state(:visible) - [current_user]).map(&:account)
    end
  end

end