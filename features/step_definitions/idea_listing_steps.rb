# actions

Then /^the idea should( not)? be listed in category "(.*?)"$/ do |negate, category|
  idea = Mentions[Idea]
  visit '/ideas'

  within first(".filter-category") do
    click_on category
  end
  page.send (negate ? :should_not : :should), have_selector("#idea_#{idea.id}")
end
