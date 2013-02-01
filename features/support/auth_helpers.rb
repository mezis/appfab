# encoding: utf-8

def current_account
  account_name = page.find('#header .team-name').text
  @current_login.accounts.find_by_name(account_name)
end