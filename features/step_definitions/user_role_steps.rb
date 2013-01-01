# actions

When /^I (give|remove) the "(.*?)" role (?:to|from) "(.*?)"$/ do |give_or_remove, role_name, first_name|
  user = User.first_name_is(first_name).last

  visit "/users/#{user.id}"
  click_on role_name.capitalize
end

#  expectations

Then /^"(.*?)" should( not)? be a (.*)$/ do |first_name, negate, role_name|
  user = User.first_name_is(first_name).last
  visit "/users/#{user.id}"
  page.send (negate ? :should_not : :should),
    have_selector('.roles', text: Regexp.new(role_name))
end