# actions

When /^I comment with "(.*?)"$/ do |body|
  idea = Mentions[Idea]
  visit "/ideas/#{idea.id}"

  fill_in 'comment_body', with: body
  click_on 'Post comment'
  Mentions[Comment] = Comment.last
end


When /^I delete the comment$/ do
  comment = Mentions[Comment]
  idea = comment.idea
  visit "/ideas/#{idea.id}"
  find("#comment#{comment.id} a.delete").click
end

# expectations

Then /^I can delete the comment$/ do
  comment = Mentions[Comment]
  idea = comment.idea
  visit "/ideas/#{idea.id}"
  page.should have_selector("#comment#{comment.id} a.delete")
end

Then /^the idea should have no comments$/ do
  comment = Mentions[Comment]
  idea = comment.idea
  visit "/ideas/#{idea.id}"
  page.should_not have_selector('#comments .comment')
end