# state

Given /^a category "(.*?)"$/ do |category|
  account = Account.last || Account.make!
  account.categories.add(category)
  account.save!
end

Given /^the account name is "(.*?)"$/ do |name|
  current_account.update_attribute :name, name
end

Given /^an account "(.*?)"$/ do |name|
  Mentions[Account] = Account.make! name:name
end

Given /^(?:I am|"(.*?)" is) a member of account "(.*?)"$/ do |who, account_name|
  account = Account.where(name: account_name).first
  login = who ? Login.where(first_name: who).first : current_login

  login.users.create! account:account
  Mentions[Account] = account
end

# actions

When /^I change my account (\w+) to "(.*?)"$/ do |field, value|
  Mentions[Account] = account = current_account
  visit "/accounts/#{account.id}/edit"
  fill_in field.capitalize, with:value
  click_on "Update Account"
end

When /^I create an account "(.*?)"$/ do |name|
  visit '/accounts/new'
  fill_in 'Name', with:name
  click_on "Create Account"
  Mentions[Account] = current_account
end

When /^I switch to the account "(.*?)"$/ do |name|
  within '#account-menu' do
    click_on name
  end
  Mentions[Account] = current_account
end

When /^I delete the account$/ do
  id = current_account.id
  visit "/accounts/#{id}"
  click_on "Destroy"
end

# expectations

Then /^the account (\w+) should be "(.*?)"/ do |field, value|
  case field
  when 'name'
    visit '/'
    page.find('#header .team-name').text.should == value

  when 'categories'
    visit '/ideas'
    text = page.first('.filter-category').text
    value.split(/\s*,\s*/).each do |category|
      text.should =~ /\b#{category}\b/
    end
  end
end

Then /^I should be prompted to create an account$/ do
  page.should have_selector('form#new_account')
end

