# encoding: UTF-8
require 'spec_helper'

describe Karma::IdeaObserver do
  let(:author)  { User.make! }
  let(:idea) { Idea.make!(:managed, author: author) }

  context 'when a idea is submitted' do
    it 'the submitter gains karma' do
      lambda { idea }.should change(author, :karma).by(1)
    end
  end

  context 'when an idea becomes vetted' do
    it 'the submitter gains karma' do
      idea.vettings.make! user: User.make!
      lambda {
        idea.vettings.make! user: User.make!
      }.should change { author.reload.karma }.by(1)
    end

    it 'notifies participants'
  end

  context 'when an idea becomes picked' do
    it 'the submitter gains karma' do
      idea.update_attribute :state, :vetted
      idea.update_attribute :product_manager_id, User.make!.id
      lambda { idea.pick» }.should change { author.reload.karma }.by(10)
    end

    it 'notifies participants'
  end

  context 'when an idea goes live' do
    it 'the submitter gains karma' do
      idea.update_attribute :state, :signed_off
      lambda { idea.deliver» }.should change { author.reload.karma }.by(20)
    end

    it 'all commenters gains karma'
    it 'notifies participants'
  end
end
