# encoding: UTF-8
Given /^I am not authenticated$/ do
  visit '/session/sign_out' # ensure that at least
end

Given /^an? (.*) named "(\w+)"$/ do |role, first_name|
  role_sym = role.split.join('_').to_sym
  last_name = Faker::Name.last_name
  email = "#{first_name}.#{last_name}@example.com"
  login = Login.make! first_name: first_name, last_name: last_name, email: email,
    provider: 'developer', uid: email
  user = User.make!(login:login)
  user.plays! role_sym unless role == 'user'

  Mentions[Login] = login
  Mentions[User] = user
end

Given /^I sign in as "(\w+)"$/ do |first_name|
  login = Login.where(first_name: first_name).first
  visit '/session/sign_out'
  visit '/session/sign_in'
  click_link 'Sign in with Developer'
  fill_in 'name',  with:login.full_name
  fill_in 'email', with:login.email
  click_on 'Sign In'
  @current_login = login

  Mentions[Login]   = login
  Mentions[Account] = current_account
end
