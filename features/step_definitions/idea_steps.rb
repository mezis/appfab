# state

Given /^an? (\w+) idea "(.*?)"?$/ do |state, title|
  user = @current_user || User.last || User.make!
  title ||= Faker::Lorem.sentence
  idea = Idea.make!(state.to_sym, author: user, title: title)
  Mentions[Idea] = idea
end

Given /"(.*)" has vetted the idea/ do |first_name|
  user = User.find_by_first_name(first_name)
  idea = Mentions[Idea]
  idea.vettings.make! user:user
end

# actions

When /^I submit an idea "(.*)"?$/ do |title|
  idea = Idea.make title:title

  visit '/ideas/new'
  fill_in 'idea_title',    with: idea.title
  fill_in 'idea_problem',  with: idea.problem
  fill_in 'idea_solution', with: idea.solution
  fill_in 'idea_metrics',  with: idea.metrics
  click_button 'Create Idea'
  Mentions[Idea] = Idea.last if Idea.last
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


# expectations

Then /^the idea should (not )?be in angle "(.*)"$/ do |negate, angle|
  idea = Mentions[Idea]
  visit "/ideas?angle=#{angle}"
  page.send(negate ? :should_not : :should, have_content(idea.title))
end

Then /^I (can|cannot) (.*) the idea?$/ do |negate, action_name|
  negate = (negate == 'cannot')
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}"

  expectation = case action_name
  when 'size'
    have_selector('a[href]', text: 'XL')
  when 'unvet'
    have_selector('a[href]', text: 'Cancel your vetting')
  when 'vet'
    have_selector('a[href]', text: 'Vet this idea')
  else
    raise NotImplementedError
  end  

  page.send(negate ? :should_not : :should, expectation) 
end


Then /^I see the idea is sized$/ do
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}"
  page.should have_content("Idea sized")
end

Then /^the idea should be (\w+)$/ do |state_name|
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}"
  find('.idea .badge.state').should have_content(state_name)
end

