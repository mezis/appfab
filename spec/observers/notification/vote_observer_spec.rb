# encoding: UTF-8
require 'spec_helper'

describe Notification::VoteObserver do
  fixtures :users, :logins, :accounts, :ideas

  context 'vote on ideas' do
    let(:voter) { User.make! }
    let(:idea) { ideas(:idea_submitted) }
    let(:vote) { Vote.make! user:voter, subject:idea }

    it 'notifies idea participants' do
      @user = User.make!
      Idea.any_instance.stub participants: [@user]
      lambda { vote }.should change(@user.notifications.of_type(:new_vote_on_idea), :count).by(1)      
    end

    it 'does not notify the voter' do
      Idea.any_instance.stub participants: [voter]
      lambda { vote }.should_not change(voter.notifications.of_type(:new_vote_on_idea), :count)
    end
  end

  context 'vote on comments' do
    let(:author) { User.make! }
    let(:vote) { Vote.make! subject: Comment.make!(author: author) }

    it 'notifies the author' do
      lambda { vote }.should change(author.notifications.of_type(:new_vote_on_comment), :count).by(1)      
    end

    it 'does not notify anyone else' do
      lambda { vote }.should change(Notification::NewVoteOnComment, :count).by(1)      
    end
  end
end
