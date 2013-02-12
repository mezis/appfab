# actions

When /^I set the idea category to "(.*?)"$/ do |category|
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}/edit"
  select(category, :from => 'idea_category')
  click_on 'Update idea'
end

