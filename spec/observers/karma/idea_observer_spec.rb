require 'spec_helper'

describe Karma::IdeaObserver do
  let(:author)  { User.make! }
  let(:idea) { Idea.make! author: author }

  context 'when a idea is submitted' do
    it 'the submitter gains karma' do
      lambda { idea }.should change(author, :karma).by(1)
    end
  end

  context 'when an idea becomes vetted' do
    it 'the submitter gains karma'
  end

  context 'when an idea becomes picked' do
    it 'the submitter gains karma'
  end

  context 'when an idea goes live' do
    it 'the submitter gains karma'
    it 'all commenters gains karma'
  end
end
