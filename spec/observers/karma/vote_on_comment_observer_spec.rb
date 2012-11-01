require 'spec_helper'

describe Karma::VoteOnCommentObserver do
  before do
    @author  = User.make!
    @comment = Comment.make! author: @author
    @voter   = User.make!
  end

  let(:vote) { Vote.make! subject: @comment, user: @voter, up: up }

  context 'when a comment is upvoted' do
    let(:up) { true }

    it 'increases the author karma' do
      lambda { vote }.should change { @author.reload.karma }.by(2)
    end

    it 'increases the voter karma' do
      lambda { vote }.should change { @voter.reload.karma }.by(1)
    end
  end

  context 'when a comment is downvoted' do
    let(:up) { false }

    it 'decreases the author karma' do
      lambda { vote }.should change { @author.reload.karma }.by(-10)
    end

    it 'decreases the voter karma' do
      lambda { vote }.should change { @voter.reload.karma }.by(-1)
    end
  end
end
