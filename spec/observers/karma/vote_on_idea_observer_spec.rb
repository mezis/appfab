# encoding: UTF-8
require 'spec_helper'

describe Karma::VoteOnIdeaObserver do
  before do
    @author = User.make!
    @idea   = Idea.make! author: @author, state: IdeaStateMachine.state_value(:vetted)
    @voter  = User.make!
  end

  let(:vote) { Vote.make! subject: @idea, user: @voter, up:true }

  context 'when an idea is voted for' do
    it 'increases the author karma' do
      lambda { vote }.should change { @author.reload.karma }.by(2)
    end

    it 'decreases the voter karma' do
      lambda { vote }.should change { @voter.reload.karma }.by(-10)
    end
  end
end
