# actions

Then /^the idea should( not)? be listed in category "(.*?)"$/ do |negate, category|
  idea = Mentions[Idea]
  visit '/ideas'
  click_on category
  page.send (negate ? :should_not : :should), have_selector("#idea#{idea.id}")
end
