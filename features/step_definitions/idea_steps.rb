# state

Given /^an? (\w+) idea "(.*?)"?$/ do |state, title|
  user = (@current_login && @current_login.users.last) || User.last || User.make!
  title ||= Faker::Lorem.sentence
  idea = Idea.make!(state.to_sym, author: user, title: title)
  Mentions[Idea] = idea
end

Given /"(.*)" has vetted the idea/ do |first_name|
  idea = Mentions[Idea]
  user = idea.account.users.first_name_is(first_name).first
  idea.vettings.make! user:user
end

Given /"(.*)" has backed the idea/ do |first_name|
  idea = Mentions[Idea]
  user = idea.account.users.first_name_is(first_name).first
  idea.votes.make! user:user
end

Given /^the idea (\w+) is "(.*?)"$/ do |field_name, value|
  idea = Mentions[Idea]
  idea.update_attribute field_name.to_sym, value
end
 
# actions

When /^I submit an? (idea|draft) "(.*)"?$/ do |idea_or_draft, title|
  idea = Idea.make(title:title).destroy

  visit '/ideas/new'
  fill_in 'idea_title',    with: idea.title
  fill_in 'idea_problem',  with: idea.problem
  fill_in 'idea_solution', with: idea.solution
  fill_in 'idea_metrics',  with: idea.metrics

  if (idea_or_draft == 'draft')
    click_button 'Save as draft'
  else
    click_button 'Submit idea'
  end
  wait_for_page_load
  Mentions[Idea] = Idea.last
end

When /^I change the (idea|draft) title to "(.*?)"$/ do |idea_or_draft, title|
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}/edit"
  fill_in 'idea_title', with:title
  click_on "Update #{idea_or_draft}"
end


When /^I (design|development)-size the idea as "(\w+)"$/ do |size_type, size|
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}"
  click_on size
end


When /^I vet the idea$/ do
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}"
  click_on "Vet this idea"
end

When /^I unvet the idea$/ do
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}"
  click_on "Cancel your vetting"
end

When /^I vote for the idea$/ do
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}"
  click_on "Vote for this"
end

When /^I cancel my vote for the idea$/ do
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}"
  click_on "Withdraw your vote"
end

When /^I approve the idea$/ do
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}"
  within '#ideas-show' do
    click_on "Approve"
  end
end

When /^I publish the draft$/ do
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}/edit"
  click_on "Submit idea"
end



# expectations

Then /^the idea should (not )?be in angle "(.*)"$/ do |negate, angle|
  idea = Mentions[Idea]
  visit "/ideas?angle=#{angle}"
  page.send(negate ? :should_not : :should, have_content(idea.title))
end

Then /^I (can|cannot) (.*) the idea?$/ do |negate, action_name|
  negate = (negate == 'cannot')
  idea = Mentions[Idea]

  expectation = case action_name
  when 'size'               then have_selector('a[href]', text: 'XL')
  when 'unvet'              then have_selector('a[href]', text: 'Cancel your vetting')
  when 'vet'                then have_selector('a[href]', text: 'Vet this idea')
  when 'vote for'           then have_selector('a[href]', text: 'Vote for this')
  when 'remove my vote for' then have_selector('a[href]', text: 'Withdraw your vote')
  when 'approve'            then have_selector('a[href]', text: 'Approve')
  else
    raise NotImplementedError
  end  

  visit "/ideas/#{idea.id}"
  within '#ideas-action' do
    page.send(negate ? :should_not : :should, expectation) 
  end
end


Then /^I see the idea is sized$/ do
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}"
  page.should have_content("Idea sized")
end

Then /^the idea should be (\w+)$/ do |state_name|
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}"
  find('.idea .state').should have_content(state_name)
end

Then /^the idea title should be "(.*?)"$/ do |title|
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}"
  find('.idea .title').should have_content(title)
end

Then /^the idea category should be "(.*?)"$/ do |category|
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}"
  find('.idea .category').should have_content(category)
end
