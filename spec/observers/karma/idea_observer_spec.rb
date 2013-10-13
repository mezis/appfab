# encoding: UTF-8
require 'spec_helper'

describe Karma::IdeaObserver do
  let(:author)  { User.make! }
  let(:idea) { Idea.make!(blueprint.to_sym, author: author) }

  context 'when a idea is submitted' do
    let(:blueprint) { :sized }
    it 'the submitter gains karma' do
      lambda { idea }.should change(author, :karma).by(1)
    end
  end

  context 'when an idea becomes vetted' do
    let(:blueprint) { :sized }

    it 'the submitter gains karma' do
      idea.vettings.make! user: User.make!
      idea.reload
      lambda {
        idea.vettings.make! user: User.make!
        idea.reload.state_machine.should be_vetted
      }.should change { author.reload.karma }.by(1)
    end
  end

  context 'when an idea becomes picked' do
    let(:blueprint) { :voted }

    it 'the submitter gains karma' do
      idea.state_machine.should be_voted
      lambda {
        idea.update_attributes! state: IdeaStateMachine.state_value(:picked)
        idea.reload.state_machine.should be_picked
      }.should change { author.reload.karma }.by(10)
    end
  end

  context 'when an idea goes live' do
    let(:blueprint) { :signed_off }
    let(:perform) {
      idea.update_attributes! state: IdeaStateMachine.state_value(:live)
    }

    it 'the submitter gains karma' do
      idea.state_machine.should be_signed_off
      lambda { perform }.should change { author.reload.karma }.by(20)
    end

    it 'all commenters gains karma' do
      commenter = User.make!
      idea.comments.make! author: commenter
      lambda { perform }.should change { commenter.reload.karma }.by(1)
    end

    it 'all backers gains karma' do
      backer = User.make!

      # adding a vote required another state for the idea
      # TODO: find a more elegant way to do this.
      idea.update_column :state, IdeaStateMachine.state_value(:vetted)
      idea.votes.make! user: backer
      idea.update_column :state, IdeaStateMachine.state_value(:signed_off)

      lambda { perform }.should change { backer.reload.karma }.by(10)
    end
  end
end
