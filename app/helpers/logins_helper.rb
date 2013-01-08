module LoginsHelper
  
  def login_other_accounts
    @login_other_accounts ||= begin
      current_login.accounts - [current_account]
    end
  end

end