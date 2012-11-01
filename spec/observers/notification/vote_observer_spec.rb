# encoding: UTF-8
require 'spec_helper'

describe Notification::VoteObserver do
  context 'vote on ideas' do
    let(:vote) { Vote.make! subject: Idea.make! }

    it 'notifies idea participants' do
      @user = User.make!
      Idea.any_instance.stub participants: [@user]
      lambda { vote }.should change(@user.notifications.of_type(:new_vote_on_idea), :count).by(1)      
    end

    it 'does not notify anyone else' do
      Idea.any_instance.stub participants: []
      lambda { vote }.should_not change(Notification::NewVoteOnIdea, :count)
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
