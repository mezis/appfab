# state

Given /^(?:I|"(.*)") (?:have|has) (\d+) karma$/ do |first_name, karma|
  login = first_name ? Login.find_by_first_name(first_name) : @current_login
  user = login.users.last
  user.update_attribute :karma, karma.to_i
end

# expectations

Then /^(?:I|"(.*?)") should have (\d+) karma$/ do |first_name, karma|
  login = first_name ? Login.find_by_first_name(first_name) : @current_login
  user = login.users.last
  visit "/users/#{user.id}"
  page.should have_content("Has #{karma}")
end
