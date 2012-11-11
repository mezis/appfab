# state

Given /^(?:I|"(.*)") (?:have|has) (\d+) karma$/ do |first_name, karma|
  user = first_name ? User.find_by_first_name(first_name) : @current_user
  user.update_attribute :karma, karma.to_i
end

# expectations

Then /^(?:I|"(.*?)") should have (\d+) karma$/ do |first_name, karma|
  user = first_name ? User.find_by_first_name(first_name) : @current_user
  visit "/users/#{user.id}"
  page.should have_content("#{user.first_name} has #{karma}")
end
