# state

Given /^a category "(.*?)"$/ do |category|
  account = Account.last || Account.make!
  account.categories.add(category)
  account.save!
end
