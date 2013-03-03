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
  find("#comment_#{comment.id} a.delete").click
end

When /^a comment "(.*?)" by "(.*?)"$/ do |body, first_name|
  idea = Mentions[Idea]
  author = idea.account.users.first_name_is(first_name).first
  comment = idea.comments.make!(author:author, body:body)
  Mentions[Comment] = comment
end

When /^I (upvote|downvote) the comment$/ do |direction|
  comment = Mentions[Comment]
  idea = comment.idea

  visit "/ideas/#{idea.id}"
  page.find("#comment_#{comment.id} a.#{direction}").click
end

Then /^the comment should be (upvoted|downvoted)$/ do |direction|
  comment = Mentions[Comment]
  idea = comment.idea

  visit "/ideas/#{idea.id}"
  page.should have_selector "#comment_#{comment.id}.#{direction}"
end


# expectations

Then /^I can delete the comment$/ do
  comment = Mentions[Comment]
  idea = comment.idea
  visit "/ideas/#{idea.id}"
  page.should have_selector("#comment_#{comment.id} a.delete")
end

Then /^the idea should have no comments$/ do
  comment = Mentions[Comment]
  idea = comment.idea
  visit "/ideas/#{idea.id}"
  page.should_not have_selector('#comments .comment')
end
