# state

Given /^a category "(.*?)"$/ do |category|
  account = Account.last || Account.make!
  account.categories.add(category)
  account.save!
end

# actions

When /^I change my account (\w+) to "(.*?)"$/ do |field, value|
  account = Mentions[Login].accounts.first
  visit "/accounts/#{account.id}/edit"
  fill_in field.capitalize, with:value
  click_on "Update Account"
end

# expectations

Then /^the account (\w+) (?:is|are) "(.*?)"/ do |field, value|
  case field
  when 'name'
    visit '/'
    page.find('#header .team-name').text.should == value

  when 'categories'
    visit '/ideas'
    text = page.find('.filter-category').text
    value.split(/\s*,\s*/).each do |category|
      text.should =~ /\b#{category}\b/
    end
  end
end