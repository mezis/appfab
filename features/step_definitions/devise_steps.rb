# encoding: UTF-8
Given /^I am not authenticated$/ do
  visit '/session/sign_out' # ensure that at least
end

Given /^an? (.*) named "(\w+)"$/ do |role, first_name|
  role_sym = role.split.join('_').to_sym
  last_name = Faker::Name.last_name
  email = "#{first_name}.#{last_name}@example.com"
  user = User.make! first_name: first_name, last_name: last_name, email: email,
    provider: 'developer', uid: email
  user.plays! role_sym unless role == 'user'
  Mentions[User] = user
end

Given /^I sign in as "(\w+)"$/ do |first_name|
  user = User.find_by_first_name(first_name)
  visit '/session/sign_out'
  visit '/session/sign_in'
  click_link 'Sign in with Developer'
  fill_in 'name',  with:user.full_name
  fill_in 'email', with:user.email
  click_on 'Sign In'
  @current_user = user
  Mentions[User] = user
end


# Given /^I am a new, authenticated user$/ do
#   email = 'testing@man.net'
#   password = 'secretpass'
#   User.new(:email => email, :password => password, :password_confirmation => password).save!

#   visit '/users/sign_in'
#   fill_in "user_email", :with=>email
#   fill_in "user_password", :with=>password
#   click_button "Sign in"
# end

