require 'spec_helper'

describe 'dashboards/show.html.haml' do
  fixtures :users, :logins, :accounts, :ideas

  subject { render ; rendered }
  let(:user) { users(:abigale_balisteri) }
  let(:idea) { ideas(:idea_submitted) }
  let(:notification) { Notification::NewIdea.make(subject:idea, recipient:user, created_at:1.hour.ago) }
  let(:comment) { Comment.make(idea:idea, author:user) }
  let(:dashboard) {
    double 'dashboard',
      block_size:                 3,
      ideas_to_size:              [idea,idea],
      ideas_recently_active:      [idea,idea],
      ideas_for_dictator:         [idea,idea],
      ideas_to_vote:              [idea,idea],
      ideas_recently_submitted:   [idea,idea],
      ideas_working_set:          [idea,idea],
      notifications_recent:       [notification],
      comments_on_followed_ideas: [comment]
  }

  login_user :user

  before { assign :dashboard, dashboard }

  it "renders" do
    subject
  end
end
