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
        idea.reload.state_name.should == :vetted
      }.should change { author.reload.karma }.by(1)
    end
  end

  context 'when an idea becomes picked' do
    let(:blueprint) { :voted }

    it 'the submitter gains karma' do
      idea.state_name.should == :voted
      lambda {
        idea.pick›
        idea.state_name.should == :picked
      }.should change { author.reload.karma }.by(10)
    end
  end

  context 'when an idea goes live' do
    let(:blueprint) { :signed_off }

    it 'the submitter gains karma' do
      idea.state_name.should == :signed_off
      lambda { idea.deliver› }.should change { author.reload.karma }.by(20)
    end

    it 'all commenters gains karma' do
      commenter = User.make!
      idea.comments.make! author: commenter
      lambda { idea.deliver› }.should change { commenter.reload.karma }.by(1)
    end

    it 'all backers gains karma' do
      backer = User.make!
      idea.votes.make! user: backer
      lambda { idea.deliver› }.should change { backer.reload.karma }.by(10)
    end
  end
end
