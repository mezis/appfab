# encoding: utf-8

def current_account
  account_name = page.find('#header .team-name').text
  current_login.accounts.where(name: account_name).first
end

def current_login
  first_name = page.find('#header .first-name').text
  Login.where(first_name: first_name).first
end
