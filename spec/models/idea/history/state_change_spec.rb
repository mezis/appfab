require 'spec_helper'

describe Idea::History::StateChange do
  fixtures :users

  context 'idea state change' do
    let(:idea) { Idea.make!(state:-1) } # draft
    let(:perform) { idea.submit» }

    it 'gets logged as history' do
      expect { perform }.to change{ described_class.count }.by(1)
    end

    it 'remembers the before/after states' do
      perform
      described_class.last.old_state.should == -1
      described_class.last.new_state.should ==  0
    end
  end
end
