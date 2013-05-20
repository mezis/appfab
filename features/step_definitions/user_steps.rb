# state

# actions

When /^I change my full name to "(.*?)"$/ do |full_name|
  first_name, last_name = full_name.split
  user = Mentions[User]
  visit "/users/#{user.id}/edit"
  fill_in 'First name', with:first_name
  fill_in 'Last name',  with:last_name
  click_on 'Update User'
end

When /^I act as "(.*?)"$/ do |first_name|
  user = Login.find_by_first_name(first_name).users.first
  visit "/users/#{user.id}"
  click_on 'Act as user'
end

When /^I act as myself$/ do
  within '#acting-as-user' do
    click_on 'click here'
  end
end

# expectations

Then /^my full name should be "(.*?)"$/ do |full_name|
  user = Mentions[User]
  visit "/users/#{user.id}"
  page.should have_content(full_name)
end

Then /^I should be "(.*?)"$/ do |first_name|
  page.find('#header .first-name').text.should == first_name
end

