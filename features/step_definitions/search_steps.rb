When(/^I search for "(.*?)"$/) do |query|
  visit root_url
  fill_in 'search_query', with: query
  click_button 'Go'
end

Then(/^I should see "(.*?)"$/) do |text|
  page.should have_text(text)
end

Then(/^I should not see "(.*?)"$/) do |text|
  page.should_not have_text(text)
end
